import 'dart:io';
import 'package:aou_online_platform/layout/user_app/cubit/states.dart';
import 'package:aou_online_platform/models/post_model.dart';
import 'package:aou_online_platform/models/user_model.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserHomeLayoutAppCubit extends Cubit<UserHomeLayoutStates> {
  UserHomeLayoutAppCubit() : super(UserHomeLayoutAppInitialState());

  static UserHomeLayoutAppCubit get(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final userNumberController = TextEditingController();
  final userMajorController = TextEditingController();
  final userIDController = TextEditingController();
  final chooseGenderController = TextEditingController();

  File? userPhoto;
  var picker = ImagePicker();
  Future<void> userPic() async {
    final userPic = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (userPic != null) {
      userPhoto = File(userPic.path);
      emit(UploadPhotoSuccessState());
    } else {
      emit(UploadPhotoErrorState('No image selected'));
    }
  }

  void getUserData() async {
    emit(LoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      model = UserModel.formJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  List<PostModel> postModels = [];
  void getPostsData() async {
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

}
