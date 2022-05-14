import 'package:aou_online_platform/layout/admin_app/admin_layout_acreen.dart';
import 'package:aou_online_platform/layout/user_app/user_layout_screen.dart';
import 'package:aou_online_platform/modules/login/cubit/login_cubit.dart';
import 'package:aou_online_platform/modules/login/cubit/login_cubit_states.dart';
import 'package:aou_online_platform/modules/signup/signup_screen.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginAppCubit(),
      child: BlocConsumer<LoginAppCubit, LoginAppStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.red,
            ));
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: "uId",
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Thanks for Login"),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.green,
              ));
              if (uId == "rTCE9Mmd0pTXvs52F5Z2hy9KIHx2") {
                navigateAndFinish(context, AdminLayoutScreen());
              } else {
                navigateAndFinish(context, const UserLayoutScreen());
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: height(context) - 100,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/logo_name.png"),
                        const SizedBox(
                          height: 20,
                        ),
                        textCustom(
                          text: "Login",
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        textCustom(
                            text: "Welcome on AOU Platform",
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 20,
                        ),
                        textFormBox(
                            textInputType: TextInputType.emailAddress,
                            nameController:
                                LoginAppCubit.get(context).emailController,
                            labelText: "Email Address",
                            hintText: "Email Address",
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Must write your email';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        textFormBox(
                          textInputType: TextInputType.visiblePassword,
                          nameController:
                              LoginAppCubit.get(context).passwordController,
                          labelText: "Password",
                          hintText: "*****************",
                          iconOn: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your password';
                            }
                            return null;
                          },
                          icon: LoginAppCubit.get(context).suffix,
                          isObscureText: LoginAppCubit.get(context).isPassword,
                          iconPress: () {
                            LoginAppCubit.get(context).togglePassword();
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            textCustom(
                              text: "Forgot your password?",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            svg(svgImage: "assets/svg/arrow.svg", width: 25)
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Center(
                            child: Container(
                              width: 250,
                              child: defaultButton(
                                text: "Login",
                                function: () {
                                  if (_formKey.currentState!.validate()) {
                                    LoginAppCubit.get(context)
                                        .loginUser(context: context);
                                  }
                                }, background: primaryColor.value,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textCustom(
                              text: "I don’t have",
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            GestureDetector(
                                onTap: () {
                                  navigateTo(context, SignUpScreen());
                                },
                                child: textCustom(
                                  text: "Account",
                                  textColor: primaryColor.value,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
