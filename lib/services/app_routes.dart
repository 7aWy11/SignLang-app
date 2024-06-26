import 'package:flutter/material.dart';
import 'package:singlanguage/pages/lessons/lesson.dart';
import 'package:singlanguage/pages/main/camera.dart';
import 'package:singlanguage/pages/main/dashboard.dart';
import 'package:singlanguage/pages/main/home.dart';
import 'package:singlanguage/pages/profile/change_password.dart';
import 'package:singlanguage/pages/profile/settings.dart';
import 'package:singlanguage/pages/profile/update_profile.dart';
import 'package:singlanguage/pages/auth/confirm_password.dart';
import 'package:singlanguage/pages/auth/forget_password.dart';
import 'package:singlanguage/pages/auth/login.dart';
import 'package:singlanguage/pages/auth/otp_password.dart';
import 'package:singlanguage/pages/auth/register.dart';
import 'package:singlanguage/pages/main/complete_profile.dart';
import 'package:singlanguage/pages/main/privacy_and_policy.dart';
import 'package:singlanguage/pages/splash/screen_1.dart';
import 'package:singlanguage/pages/splash/screen_2.dart';
import 'package:singlanguage/pages/splash/screen_3.dart';
import 'package:singlanguage/pages/splash/screen_4.dart';
import 'package:get/get.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    SplashScreen.routeName: (context) => const SplashScreen(),
    SplashScreenTwo.routeName: (context) => SplashScreenTwo(),
    SplashScreenThree.routeName: (context) => SplashScreenThree(),
    SplashScreenFour.routeName: (context) => SplashScreenFour(),
    LoginScreen.routeName: (context) => LoginScreen(),
    SignupScreen.routeName: (context) => SignupScreen(),
    PrivacyPolicyScreen.routeName: (context) => PrivacyPolicyScreen(),
    ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
    ConfirmEmailScreen.routeName: (context) => ConfirmEmailScreen(),
    ConfirmPasswordScreen.routeName: (context) => ConfirmPasswordScreen(),
    CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
    HomeScreen.routeName: (context) => HomeScreen(),
    ProfileScreen.routeName: (context) => ProfileScreen(),
    UpdateProfileScreen.routeName: (context) => UpdateProfileScreen(),
    ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
    LessonScreen.routeName: (context) => LessonScreen(),
    CameraScreen.routeName: (context) => CameraScreen(),
    DashboardScreen.routeName: (context) => DashboardScreen(),
  };
}
