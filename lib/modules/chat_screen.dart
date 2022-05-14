import 'dart:math';
import 'dart:ui';

import 'package:aou_online_platform/models/user_model.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  String receiverId;

  ChatScreen({required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> listChatMessages = [];

  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getMessage(widget.receiverId);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: primaryColor.value,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: size.height * 0.8,
                  child: ListView.builder(
                      itemCount: listChatMessages.length,
                      itemBuilder: (context, index) {
                        String senderId =
                            model?.userID ?? "rTCE9Mmd0pTXvs52F5Z2hy9KIHx2";
                        MessageModel message = listChatMessages[index];
                        return (message.senderId == senderId)
                            ? senderWidget(size, message)
                            : reciverWidget(size, message);
                      }),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Type a message ... ",
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor.value,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (chatController.text.isNotEmpty) {
                          await sendMessage(
                            MessageModel(
                              dateTime: DateTime.now().toString(),
                              receiverId: widget.receiverId,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              content: chatController.text,
                              index: 0,
                              idMessage: "",
                              nameReceiver: "Admin",
                              nameSender: model?.userName ?? "",
                              profileImageReceiver:
                                  "https://firebasestorage.googleapis.com/v0/b/aou-complaint-system.appspot.com/o/users%2Fimage_picker1501666339.png?alt=media&token=86f8f62b-4045-48cc-94f2-83ad67cce13c",
                              profileImageSender: model?.userImage ?? "",
                            ),
                            UserModel(
                              userImage:
                                  "https://firebasestorage.googleapis.com/v0/b/aou-complaint-system.appspot.com/o/users%2Fimage_picker1501666339.png?alt=media&token=86f8f62b-4045-48cc-94f2-83ad67cce13c",
                              userName: "Admin",
                              userEmail: "admin@admin.com",
                              userNumber: "599904494",
                              major: "IT",
                              gender: "Female",
                              ID: "45434548",
                              userID: widget.receiverId,
                            ),
                          );
                          chatController.clear();
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: primaryColor.value,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: chatController,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align reciverWidget(Size size, MessageModel message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.01,
        ),
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              (DateFormat.jm().format(DateTime.parse(message.dateTime)))
                  .toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget senderWidget(Size size, MessageModel message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.01,
        ),
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              (DateFormat.jm().format(DateTime.parse(message.dateTime)))
                  .toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: primaryColor.value,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  getMessage(String receiveId) {
    String userId = "";

    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.userID ?? "rTCE9Mmd0pTXvs52F5Z2hy9KIHx2")
        .collection('Chat')
        .doc(receiveId)
        .collection("Messages")
        .orderBy("index")
        .snapshots()
        .listen((event) {
      listChatMessages = [];
      for (var element in event.docs) {
        setState(() {
          listChatMessages.add(MessageModel.fromMap(element.data()));
        });
      }
    });
  }

  sendMessage(MessageModel message, UserModel receiverUserMessage) async {
    int x = listChatMessages.length + 1;
    listChatMessages.isEmpty ? message.index = 1 : message.index = x;

    message.idMessage = generateRandomString(20);

    await sendMessageUser(message);

    if (message.index == 1) {
      saveInSUer();
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  sendMessageUser(MessageModel message) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.userID ?? "rTCE9Mmd0pTXvs52F5Z2hy9KIHx2")
        .collection("Chat")
        .doc(message.receiverId)
        .collection('Messages')
        .doc(message.idMessage)
        .set(message.toMap());

    FirebaseFirestore.instance
        .collection("users")
        .doc(message.receiverId)
        .collection("Chat")
        .doc(model?.userID ?? "rTCE9Mmd0pTXvs52F5Z2hy9KIHx2")
        .collection('Messages')
        .doc(message.idMessage)
        .set(message.toMap());
  }

  saveInSUer() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("rTCE9Mmd0pTXvs52F5Z2hy9KIHx2")
        .collection("ChatUser")
        .doc(model!.userID)
        .set(model!.toJson());
  }
}
