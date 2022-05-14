import 'package:aou_online_platform/layout/admin_app/cubit/cubit.dart';
import 'package:aou_online_platform/layout/admin_app/cubit/states.dart';
import 'package:aou_online_platform/models/post_model.dart';
import 'package:aou_online_platform/modules/login/login_screen.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/list_chat_screen.dart';
import '../../modules/list_user.dart';
import '../../modules/qr_code/scan_qr_code_.dart';

class AdminLayoutScreen extends StatelessWidget {
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<AdminHomeLayoutAppCubit, AdminHomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetPostsDataLoadingState) {
          return Scaffold(
            body: circularProgress(),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: drawerWidget(context),
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text('Admin'),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: addPost(context),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: CarouselSlider(
              options: CarouselOptions(
                height: size.height * 0.5,
                autoPlay: true,
              ),
              items: AdminHomeLayoutAppCubit.get(context).postModels.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return postItem(context, i, size);
                  },
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  Drawer drawerWidget(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/logo_name.png', width: 100),
                  radius: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Admin',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          listTile(
            iconData: Icons.qr_code_scanner,
            text: 'QR Code',
            onTap: () {
              navigateTo(context, ScanQRScreen());
            },
          ),
          listTile(
            iconData: Icons.person,
            text: 'Users',
            onTap: () {
              navigateTo(context, ListUser());
            },
          ),
          listTile(
            iconData: Icons.chat,
            text: 'Chat',
            onTap: () {
              navigateTo(context, ListChatScreen());
            },
          ),
          listTile(
            iconData: Icons.logout,
            text: 'Logout',
            onTap: () {
              CacheHelper.remove(key: "uId");
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Logout"),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.green,
              ));
              navigateAndFinish(context, LoginScreen());
            },
          )
        ],
      ),
    );
  }

  Widget addPost(context) =>
      BlocConsumer<AdminHomeLayoutAppCubit, AdminHomeLayoutStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    children: [
                      const Text(
                        'Add Post',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          AdminHomeLayoutAppCubit.get(context).postPic();
                        },
                        child: Container(
                          width: double.infinity,
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AdminHomeLayoutAppCubit.get(context).PostPhoto !=
                                      null
                                  ? Image.file(
                                      AdminHomeLayoutAppCubit.get(context)
                                          .PostPhoto!,
                                      height: 200,
                                      width: double.infinity,
                                    )
                                  : const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 150,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textFormBox(
                          textInputType: TextInputType.text,
                          nameController: postController,
                          labelText: "about post",
                          hintText: "about post",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must write about post';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor),
                              child: TextButton(
                                onPressed: () async {
                                  AdminHomeLayoutAppCubit.get(context)
                                      .uploadPostPhoto(
                                          text: postController.text,
                                          context: context);
                                  postController.text = '';
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget listTile(
          {required IconData iconData,
          required String text,
          required var onTap}) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(iconData),
                  Text(text),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      );

  Widget postItem(context, PostModel postModel, Size size) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  child:
                      Image.network(postModel.postImage, fit: BoxFit.contain),
                  color: Colors.grey.shade100,
                  width: size.width,
                  height: size.height * 0.3,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    postModel.aboutPost,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
