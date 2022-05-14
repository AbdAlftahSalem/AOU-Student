import 'package:aou_online_platform/layout/user_app/cubit/cubit.dart';
import 'package:aou_online_platform/layout/user_app/cubit/states.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController avgController = TextEditingController();
  String statement = '';

  getAVG() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(model?.userID ?? "")
        .collection("AVG")
        .doc(model?.userID ?? "")
        .get()
        .then((value) {
      setState(() {
        avgController.text = value.data()!["AVG"].toString();
        statement = value.data()!["statement"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAVG();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = UserHomeLayoutAppCubit.get(context);
    cubit.userMajorController.text = model!.major;
    cubit.userIDController.text = model!.ID;
    cubit.chooseGenderController.text = model!.gender;
    cubit.userNumberController.text = model!.userNumber;
    cubit.nameController.text = model!.userName;
    cubit.emailController.text = model!.userEmail;
    return BlocConsumer<UserHomeLayoutAppCubit, UserHomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: BuildCondition(
            condition: model != null,
            builder: (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 350,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_name.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              model!.userImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      model!.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController:
                            UserHomeLayoutAppCubit.get(context).emailController,
                        labelText: "Email Address",
                        hintText: "Email Address",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController:
                            UserHomeLayoutAppCubit.get(context).nameController,
                        labelText: "Name",
                        hintText: "Name",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.phone,
                        nameController: UserHomeLayoutAppCubit.get(context)
                            .userNumberController,
                        labelText: "Phone",
                        hintText: "Phone number",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController: UserHomeLayoutAppCubit.get(context)
                            .userIDController,
                        labelText: "ID",
                        hintText: "ID",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController: UserHomeLayoutAppCubit.get(context)
                            .chooseGenderController,
                        labelText: "Gender",
                        hintText: "Gender",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController: UserHomeLayoutAppCubit.get(context)
                            .userMajorController,
                        labelText: "Major",
                        hintText: "Major",
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Must write your email';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textFormBox(
                        readOnly: true,
                        textInputType: TextInputType.emailAddress,
                        nameController: avgController,
                        labelText: "AVG",
                        hintText: "AVG",
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        statement,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Choose Color app :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          primaryColor.value = Colors.red;
                          ValueNotifier(Colors.red);
                          EasyLoading.showSuccess(
                            "Success",
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.check,
                            color: primaryColor.value == Colors.red
                                ? Colors.white
                                : Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          primaryColor.value = Colors.blue;
                          ValueNotifier(Colors.blue);
                          EasyLoading.showSuccess(
                            "Success",
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.check,
                            color: primaryColor.value == Colors.blue
                                ? Colors.white
                                : Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          primaryColor.value = Colors.teal;
                          ValueNotifier(Colors.teal);
                          EasyLoading.showSuccess(
                            "Success",
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.check,
                            color: primaryColor.value == Colors.teal
                                ? Colors.white
                                : Colors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
