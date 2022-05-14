import 'package:aou_online_platform/modules/on_boarding/on_boarding_screen.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 3),
            () {
          navigateAndFinish(context, const OnBoardingScreen());
        }
    );
    return Scaffold(
      body: Center(child: Image.asset("assets/images/logo_name.png")),
    );
  }
}
