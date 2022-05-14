import 'package:aou_online_platform/models/user_model.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detail_user_screen.dart';

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  List<UserModel> users = [];

  getStudent() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        setState(() {
          element.data()["userEmail"] == "admin@admin.com"
              ? print("")
              : users.add(UserModel.formJson(element.data()));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
        backgroundColor: primaryColor.value,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: users.map((e) {
            return InkWell(
              onTap: () {
                navigateTo(context , DetailUserScreen(userModel: e));
              },
              child: Container(
                child: ListTile(
                  title: Text(e.userName),
                  subtitle: Text(e.userEmail),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(e.userImage),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
