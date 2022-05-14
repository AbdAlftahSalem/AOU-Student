import 'package:aou_online_platform/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/components/components.dart';
import '../shared/style/color.dart';
import 'chat_screen.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({Key? key}) : super(key: key);

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  List<UserModel> listUser = [];

  getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("rTCE9Mmd0pTXvs52F5Z2hy9KIHx2")
        .collection("ChatUser")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          listUser.add(UserModel.formJson(element.data()));
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Chat'),
        backgroundColor: primaryColor.value,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .05,
            vertical: MediaQuery.of(context).size.height * .02),
        child: Column(
          children: listUser.map((e) {
            return InkWell(
              onTap: () {
                navigateTo(context, ChatScreen(receiverId: e.userID));
              },
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(e.userImage),
                  ),
                  title: Text(e.userName),
                  subtitle: Text(e.userEmail),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
