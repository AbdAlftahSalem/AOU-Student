import 'dart:io';

import 'package:aou_online_platform/layout/user_app/cubit/cubit.dart';
import 'package:aou_online_platform/layout/user_app/cubit/states.dart';
import 'package:aou_online_platform/models/post_model.dart';
import 'package:aou_online_platform/modules/login/login_screen.dart';
import 'package:aou_online_platform/modules/profile/profile_screen.dart';
import 'package:aou_online_platform/modules/qr_code/qr_code_screen.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../modules/chat_screen.dart';
import '../../modules/lecture_screen.dart';
import '../../shared/style/color.dart';

class UserLayoutScreen extends StatelessWidget {
  const UserLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<UserHomeLayoutAppCubit, UserHomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingProfileState || state is LoadingState) {
          return Scaffold(
            body: circularProgress(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor.value,
              title: Text(model?.userName ?? ''),
            ),
            drawer: (drawerWidget(context)),
            body: CarouselSlider(
              options: CarouselOptions(
                height: size.height * 0.5,
                autoPlay: true,
              ),
              items: UserHomeLayoutAppCubit.get(context).postModels.map((i) {
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
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                model?.userImage == null
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('assets/images/logo_name.png',
                            width: 100),
                        radius: 70,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(model?.userImage ?? ''),
                        radius: 70,
                      ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  model?.userName ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  model?.userEmail ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          listTile(
            iconData: Icons.person,
            text: 'Profile',
            onTap: () {
              navigateTo(context, const ProfileScreen());
            },
          ),
          listTile(
            iconData: Icons.qr_code_scanner,
            text: 'QR Code',
            onTap: () {
              navigateTo(context, QrCodeScreen());
            },
          ),
          listTile(
            iconData: Icons.list,
            text: 'Lecture',
            onTap: () {
              navigateTo(context, const LectureScreen());
            },
          ),
          listTile(
            iconData: Icons.list,
            text: 'Download schedule',
            onTap: () async {
              EasyLoading.show(status: 'Downloading...');
              await save();
              EasyLoading.dismiss();
              EasyLoading.showSuccess(
                "Downloaded successfully",
                duration: const Duration(seconds: 2),
              );
            },
          ),
          listTile(
            iconData: Icons.chat,
            text: 'Chat',
            onTap: () {
              navigateTo(
                context,
                ChatScreen(
                  receiverId: 'rTCE9Mmd0pTXvs52F5Z2hy9KIHx2',
                ),
              );
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
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () =>
                    launchUrl("https://sisksa.aou.edu.kw/OnlineServices/"),
                child: iconDataMethod(FontAwesomeIcons.graduationCap, 'SIS'),
              ),
              InkWell(
                onTap: () => launchUrl("https://mdl.arabou.edu.kw/ksa/"),
                child: iconDataMethod(Icons.assignment, 'LMS'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Column iconDataMethod(IconData iconData, String text) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          child: Center(
            child: Icon(
              iconData,
              color: Colors.black,
              // size: 30,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(text, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

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

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  save() async {
    var path =
        "https://firebasestorage.googleapis.com/v0/b/aou-complaint-system.appspot.com/o/schedule%2Fschedule.jpeg?alt=media&token=87dc630e-a320-48bd-9bff-2d04246a0975";
    await GallerySaver.saveImage(path, toDcim: true);
  }
}
