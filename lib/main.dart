import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp2023/layout/applicant_layout/applicant_layout.dart';
import 'package:gp2023/modules/applicant_home_module/cubit/cubit.dart';
import 'package:gp2023/shared/bloc_observer.dart';
import 'package:gp2023/shared/styles/themes.dart';
import 'package:gp2023/shared/cubit/cubit.dart';
import 'package:gp2023/shared/cubit/states.dart';
import 'package:gp2023/modules/login_module/login.dart';
import 'package:gp2023/layout/home_layout/cubit/cubit.dart';
import 'package:gp2023/layout/applicant_layout/cubit/cubit.dart';
import './shared/network/local/cache_helper.dart';
import './shared/components/constants.dart';
import 'layout/hr_layout/cubit/cubit.dart';
import 'package:flutter/rendering.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  //token = CacheHelper.getData(key: 'token');

  uId = CacheHelper.getData(key: 'uId');

  // if(onBoarding != null)
  // {
  //   if(token != null) widget = ShopLayout();
  //   else widget = ShopLoginScreen();
  // } else
  //   {
  //     widget = OnBoardingScreen();
  //   }

  if (uId != null) {
    widget = const ApplicantLayout();
  } else {
    widget = WorkableLoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget {
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  const MyApp({
    Key key,
    this.isDark,
    this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => WorkableCubit()..getUserData(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              ApplicantCubit()..getApplicantString(),
        ),
        BlocProvider(
          create: (BuildContext context) => HrCubit()..getHrString(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              ApplicantRegisterCubit()..getApplicantRegisterString(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
