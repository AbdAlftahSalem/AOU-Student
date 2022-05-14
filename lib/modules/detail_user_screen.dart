import 'package:aou_online_platform/models/user_model.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../shared/style/widgets.dart';

class DetailUserScreen extends StatefulWidget {
  UserModel userModel;

  DetailUserScreen({required this.userModel});

  @override
  State<DetailUserScreen> createState() => _DetailUserScreenState();
}

class _DetailUserScreenState extends State<DetailUserScreen> {
  TextEditingController avgController = TextEditingController();
  String avg = "";

  getAVG() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.userID)
        .collection("AVG")
        .doc(widget.userModel.userID)
        .get()
        .then((value) {
      setState(() {
        avgController.text = value.data()!["AVG"].toString();
      });
    });
  }

  addAVG() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.userID)
        .collection("AVG")
        .doc(widget.userModel.userID)
        .set({
      "AVG": avgController.text,
      "statement": addStatement(),
    });
  }

  addStatement() {
    double avg = double.parse(avgController.text);
    if (avg <= 4.0 && avg >= 3.76) {
      return "Honors: Our university is proud of.";
    } else if (avg <= 3.76 && avg >= 3.5) {
      return "Excellent: Outstanding student, you are doing a great job.";
    } else if (avg <= 3.49 && avg >= 3) {
      return "Very good:  Great job.";
    } else {
      return "good : well done.";
    }
  }

  @override
  void initState() {
    super.initState();
    getAVG();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel.userName),
        backgroundColor: primaryColor.value,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .05, vertical: size.height * .02),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.userModel.userImage,
                  width: size.width,
                  height: size.height * .4,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: size.height * .02),
              detailUser("Name : ", widget.userModel.userName),
              detailUser("Email : ", widget.userModel.userEmail),
              detailUser("User number : ", widget.userModel.userNumber),
              detailUser("ID : ", widget.userModel.ID),
              detailUser("Gender : ", widget.userModel.gender),
              detailUser("Major : ", widget.userModel.major),
              detailUser("AVG : ", avgController.text),
              SizedBox(height: size.height * .02),
              avgController.text.isEmpty
                  ? Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            label: Text("AVG"),
                            hintText: "Enter AVG",
                          ),
                          controller: avgController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: size.height * .02),
                        defaultButton(
                          text: 'Update',
                          function: () {
                            if (avgController.text.isNotEmpty) {
                              addAVG();
                              setState(() {
                                avg = avgController.text;
                              });
                            }
                          },
                          background: primaryColor.value,
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailUser(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
