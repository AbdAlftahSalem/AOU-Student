import 'package:aou_online_platform/layout/admin_app/admin_layout_acreen.dart';
import 'package:aou_online_platform/layout/admin_app/cubit/cubit.dart';
import 'package:aou_online_platform/layout/user_app/cubit/cubit.dart';
import 'package:aou_online_platform/layout/user_app/user_layout_screen.dart';
import 'package:aou_online_platform/modules/splash/splash_screen.dart';
import 'package:aou_online_platform/shared/components/constants.dart';
import 'package:aou_online_platform/shared/cubit/bloc_observer.dart';
import 'package:aou_online_platform/shared/cubit/cubit.dart';
import 'package:aou_online_platform/shared/cubit/states.dart';
import 'package:aou_online_platform/shared/network/local/cache_helper.dart';
import 'package:aou_online_platform/shared/style/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();

// 28dNRR9sEjWnlArt6Nf3b9Hs1NX2
// rTCE9Mmd0pTXvs52F5Z2hy9KIHx2
  Widget widget;
  uId = CacheHelper.getData(key: "uId");
  if (uId != null) {
    if (uId == 'rTCE9Mmd0pTXvs52F5Z2hy9KIHx2') {
      widget = AdminLayoutScreen();
    } else {
      widget = const UserLayoutScreen();
    }
  } else {
    widget = SplashScreen();
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => AdminHomeLayoutAppCubit()..getPostsData(),
        ),
        BlocProvider(
          create: (context) => UserHomeLayoutAppCubit()
            ..getUserData()
            ..getPostsData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, states) {
          return ValueListenableBuilder<Color>(
            valueListenable: primaryColor,
            builder: (context, color, child) {
              return MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: primaryColor.value,
                ),
                home: startWidget,
                builder: EasyLoading.init(),
              );
            },
          );
        },
      ),
    );
  }
}
