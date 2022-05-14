import 'dart:io';
import 'package:aou_online_platform/models/post_model.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:aou_online_platform/layout/admin_app/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class AdminHomeLayoutAppCubit extends Cubit<AdminHomeLayoutStates> {
  AdminHomeLayoutAppCubit() : super(AdminHomeLayoutAppInitialState());

  static AdminHomeLayoutAppCubit get(context) => BlocProvider.of(context);

  File? PostPhoto;
  var picker = ImagePicker();

  Future<void> postPic() async {
    final postPic = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (postPic != null) {
      PostPhoto = File(postPic.path);
      emit(UploadPhotoSuccessState());
    } else {
      emit(UploadPhotoErrorState('No image selected'));
    }
  }

  void uploadPostPhoto({required String text, required context}) async {
    EasyLoading.show(status: 'loading...');
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(PostPhoto!.path).pathSegments.last}")
        .putFile(PostPhoto!)
        .then((tour) {
      tour.ref.getDownloadURL().then((postPhoto) async {
        uploadPost(
            context: context,
            text: text,
            photo: postPhoto == null ? "" : postPhoto);
        emit(UploadPhotoToDBSuccessState());
      }).catchError((error) {
        emit(UploadPhotoToDBErrorState(error.toString()));
      });
      emit(UploadPhotoToDBSuccessState());
    }).catchError((error) {
      emit(UploadPhotoToDBErrorState(error.toString()));
    });
    EasyLoading.dismiss();
    EasyLoading.showSuccess("Post Uploaded", duration: Duration(seconds: 2));
  }

  List<PostModel> postModels = [];

  void getPostsData() async {
    emit(GetPostsDataLoadingState());
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        postModels.add(PostModel.formJson(element.data()));
        emit(GetPostsDataSuccessState());
      });
    }).catchError((error) {
      emit(GetPostsDataErrorState(error.toString()));
    });
  }

  void uploadPost(
      {required String photo, required String text, required context}) {
    PostModel postModel = PostModel(postImage: photo, aboutPost: text);
    FirebaseFirestore.instance
        .collection("posts")
        .add(postModel.toJson())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post Added'),
        duration: const Duration(seconds: 4),
        backgroundColor: primaryColor.value,
      ));
      PostPhoto = null;
      getPostsData();
      Navigator.pop(context);
      emit(UploadPostSuccessState());
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: const Duration(seconds: 4),
        backgroundColor: primaryColor.value,
      ));
      Navigator.pop(context);
      emit(UploadPostErrorState(error.toString()));
    });
  }
}
