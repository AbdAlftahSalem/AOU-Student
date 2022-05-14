import 'package:aou_online_platform/modules/login/login_screen.dart';
import 'package:aou_online_platform/shared/components/components.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image: "assets/svg/onboarding1.svg",
        title: "Title",
        body: "Body ....."),
    BoardingModel(
        image: "assets/svg/onboarding2.svg",
        title: "Title",
        body: "Body ....."),
    BoardingModel(
        image: "assets/svg/onboarding3.svg",
        title: "Title",
        body: "Body ....."),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: "onBoarding",
      value: true,
    ).then((value) {
      if (value) {
        return navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: (){
                setState(() {
                  submit();
                });
              },
              child:  Text(
                'Skip',
                style: TextStyle(color: primaryColor.value),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10.0,
                    expansionFactor: 4,
                    dotWidth: 10.0,
                    spacing: 5,
                    activeDotColor: primaryColor.value,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: primaryColor.value,
                  onPressed: () {
                    if (isLast) {
                      submit();

                    } else {
                      boardController.nextPage(
                        duration: const Duration(
                          microseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    children: [
      Expanded(
        child: Center(
          child: SvgPicture.asset(
            model.image,
            width: 250,
          ),
        ),
      ),
      Text(
        model.title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 15.0,
      ),
      Text(
        model.body,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 15.0,
      ),
    ],
  );
}
