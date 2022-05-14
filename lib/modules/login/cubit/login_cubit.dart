import 'package:aou_online_platform/modules/login/cubit/login_cubit_states.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginAppCubit extends Cubit<LoginAppStates> {
  LoginAppCubit() : super(LoginAppInitialState());

  static LoginAppCubit get(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  togglePassword() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(TogglePassword());
  }

  loginUser({
    required BuildContext context,
  }) {
    emit(LoginLoading());
    onLoading(context);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((value) {
      Navigator.pop(context);
      emit(
        LoginSuccessState(value.user!.uid),
      );
    }).catchError((e) {
      Navigator.pop(context);
      emit(LoginErrorState(e.toString()));
    });
  }

  void onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => circularProgress());
  }
}
