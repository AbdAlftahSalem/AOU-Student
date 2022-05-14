import 'dart:ui';

import 'package:aou_online_platform/models/lecture_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LectureScreen extends StatefulWidget {
  const LectureScreen({Key? key}) : super(key: key);

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  List<LectureModel> lectureList = [];
  bool isLoading = false;
  String now = DateFormat('EEEE').format(DateTime.now());

  x(String day) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("lecture")
        .doc(day)
        .get()
        .then((value) {
      if (value.data() != null) {
        setState(() {
          lectureList.add(LectureModel.fromJson(value.data()!));
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    x(now.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              now,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : lectureList.isEmpty
                    ? const Padding(
                      padding:  EdgeInsets.symmetric(vertical: 50),
                      child: Center(
                          child: Text(
                          "No Lecture Today",
                          style: TextStyle(fontWeight: FontWeight.w800 , fontSize: 20),
                        )),
                    )
                    : Column(
                        children: lectureList[0].subjects!.map((e) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                e.time!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: Text(
                                e.subject!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }
}
