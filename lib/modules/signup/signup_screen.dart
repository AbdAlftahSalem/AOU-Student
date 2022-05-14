import 'package:aou_online_platform/modules/signup/cubit/sign_up_cubit.dart';
import 'package:aou_online_platform/modules/signup/cubit/sign_up_states.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  List<String> gender = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpAppCubit(),
      child: BlocConsumer<SignUpAppCubit, SignUpAppStates>(
        listener: (context, state) {
          if (state is SignUpLoading) {
             Center(
              child: CircularProgressIndicator(
                color: primaryColor.value,
              ),
            );
          }
          if (state is SignUpCreateUSerSuccessState) {
            Navigator.pop(context);
          }
          if (state is SignUpCreateUSerErrorState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColors,
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: backgroundColors,
              elevation: 0.0,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textCustom(
                        text: "SIGN UP",
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          SignUpAppCubit.get(context).profilePic();
                        },
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            child: SignUpAppCubit.get(context).profilePhoto !=
                                    null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(
                                      SignUpAppCubit.get(context).profilePhoto!,
                                    ),
                                    /*child: Image(image: FileImage(SignUpAppCubit.get(context)
                                  .profilePhoto!),
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover,)*/
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      'assets/images/logo_name.png',
                                      height: 250,
                                      width: 250,
                                    ),
                                  ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFe0f2f1)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.text,
                          nameController:
                              SignUpAppCubit.get(context).nameController,
                          labelText: "Full name",
                          hintText: "Full name",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your full name';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.emailAddress,
                          nameController:
                              SignUpAppCubit.get(context).emailController,
                          labelText: "Email Address",
                          hintText: "info@egyTour.com",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your email address';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.number,
                          nameController:
                              SignUpAppCubit.get(context).userNumberController,
                          labelText: "Phone number",
                          hintText: "Phone number",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your phone number';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.text,
                          nameController: SignUpAppCubit.get(context).userMajorController,
                          labelText: "Major",
                          hintText: "Major",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your Major';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.text,
                          nameController: SignUpAppCubit.get(context).userIDController,
                          labelText: "ID",
                          hintText: "ID",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your ID';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButtonFormField(
                        items: gender
                            .map(
                              (map) => DropdownMenuItem(
                            child: Text(map),
                            value: map,
                          ),
                        )
                            .toList(),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                        ),
                        hint: const Text('Choose gender'),
                        onChanged: (value) {
                          print(value);
                          SignUpAppCubit.get(context).chooseGenderController.text = value.toString();
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.visiblePassword,
                          nameController:
                              SignUpAppCubit.get(context).passwordController,
                          labelText: "Password",
                          hintText: "*****************",
                          iconOn: true,
                          icon: SignUpAppCubit.get(context).suffix,
                          isObscureText: SignUpAppCubit.get(context).isPassword,
                          iconPress: () {
                            SignUpAppCubit.get(context).togglePassword();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write your password';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                      textFormBox(
                          textInputType: TextInputType.visiblePassword,
                          nameController: SignUpAppCubit.get(context)
                              .conformPasswordController,
                          labelText: "Conform Password",
                          hintText: "*****************",
                          iconOn: true,
                          icon: SignUpAppCubit.get(context).suffix,
                          isObscureText: SignUpAppCubit.get(context).isPassword,
                          iconPress: () {
                            SignUpAppCubit.get(context).togglePassword();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must rewrite your password';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          textCustom(
                            text: "Already have an account?",
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
                              text: "SIGN UP",
                              function: () {
                                if (_formKey.currentState!.validate()) {
                                  if (SignUpAppCubit.get(context)
                                          .profilePhoto !=
                                      null) {
                                    SignUpAppCubit.get(context).signUp(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            const Text('Please choose your photo'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }, background: primaryColor.value,
                            ),
                          ),
                        ),
                      ),
                    ],
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
