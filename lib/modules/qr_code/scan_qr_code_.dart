import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aou_online_platform/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  QRViewController? controller;
  UserModel userModel = UserModel(
    gender: '',
    major: '',
    userImage: '',
    userID: '',
    userName: '',
    userEmail: '',
    userNumber: '',
    ID: '',
  );

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel.userID.isEmpty
          ? Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    cameraFacing: CameraFacing.back,
                    overlay: QrScannerOverlayShape(
                      cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      borderWidth: 10,
                      borderLength: 20,
                      borderRadius: 10,
                      borderColor: Colors.teal,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Catch data success !",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  // child: Text(result?.code ?? ''),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User name : ${userModel.userName}"),
                    Text("User email : ${userModel.userEmail}"),
                    Text("User ID     :   ${userModel.userID}"),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  child: const Text(
                    "Uploading data to database",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(() {
          result = scanData;
          userModel = UserModel.formJson(jsonDecode(result?.code ?? ''));
          print("//////////////////////////////////////////////");
          print(userModel.gender);
        });
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
