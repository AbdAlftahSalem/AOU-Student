import 'dart:io';

import 'package:aou_online_platform/models/user_model.dart';
import 'package:aou_online_platform/modules/login/login_screen.dart';
import 'package:aou_online_platform/modules/signup/cubit/sign_up_states.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class SignUpAppCubit extends Cubit<SignUpAppStates> {
  SignUpAppCubit() : super(SignUpAppInitialState());

  static SignUpAppCubit get(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final userNumberController = TextEditingController();
  final userMajorController = TextEditingController();
  final userIDController = TextEditingController();
  final passwordController = TextEditingController();
  final conformPasswordController = TextEditingController();
  final chooseGenderController = TextEditingController();

  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  togglePassword() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(TogglePassword());
  }

  void signUp(context) {
    emit(SignUpLoading());
    onLoading(context);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .catchError((onError) {
      emit(SignUpCreateUSerErrorState(onError.toString()));
    }).then((value) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(profilePhoto!.path).pathSegments.last}")
          .putFile(profilePhoto!)
          .then((tour) {
        tour.ref.getDownloadURL().then((profilePhoto) {
          createUser(
            context: context,
            userEmail: emailController.text,
            userImage: profilePhoto == null ? "" : profilePhoto,
            userName: nameController.text,
            userNumber: userNumberController.text,
            ID: userIDController.text,
            major: userMajorController.text,
            gender: chooseGenderController.text,
            uId: value.user!.uid,
          );
        }).catchError((error) {});
      }).catchError((error) {});
    });
  }

  void createUser({
    required String userEmail,
    required String userName,
    required String userNumber,
    required String userImage,
    required String ID,
    required String major,
    required String gender,
    required String uId,
    context,
  }) {
    UserModel userModel = UserModel(
      userEmail: userEmail,
      gender: gender,
      major: major,
      ID: ID,
      userID: uId,
      userImage: userImage,
      userName: userName,
      userNumber: userNumber,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(userModel.toJson())
        .then((value) {
      CacheHelper.saveData(
        key: "UID",
        value: uId,
      ).then((value) {
        if (value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Thanks for signup"),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
          ));
          navigateAndFinish(context, LoginScreen());
        }
      });
      Navigator.pop(context);
      emit(SignUpCreateUSerSuccessState());
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: const Duration(seconds: 4),
        backgroundColor: primaryColor.value,
      ));
      Navigator.pop(context);
      emit(SignUpCreateUSerErrorState(error.toString()));
    });
  }

  File? profilePhoto;
  var picker = ImagePicker();

  Future<void> profilePic() async {
    final profilePic = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (profilePic != null) {
      profilePhoto = File(profilePic.path);
      emit(UploadPhotoSuccessState());
    } else {
      emit(UploadPhotoErrorState('No image selected'));
    }
  }

  void onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => circularProgress());
  }
}
