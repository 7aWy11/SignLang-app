import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singlanguage/pages/lessons/lesson.dart';
import 'package:singlanguage/pages/main/home.dart';
import 'package:singlanguage/pages/profile/change_password.dart';
import 'package:singlanguage/pages/profile/settings.dart';
import 'package:singlanguage/pages/profile/update_profile.dart';
import 'pages/auth/confirm_password.dart';
import 'pages/auth/forget_password.dart';
import 'pages/auth/login.dart';
import 'pages/auth/otp_password.dart';
import 'pages/auth/register.dart';
import 'pages/main/complete_profile.dart';
import 'pages/main/privacy_and_policy.dart';
import 'pages/splash/screen_1.dart';
import 'pages/splash/screen_2.dart';
import 'pages/splash/screen_3.dart';
import 'pages/splash/screen_4.dart';
import 'package:get/get.dart';

void main() {
  runApp(const SignLang());
}

class SignLang extends StatefulWidget {
  const SignLang({super.key});

  @override
  State<SignLang> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SignLang> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routName,
      routes: {
        SplashScreen.routName: (context) => const SplashScreen(),
        SplashScreenTwo.routName: (context) => SplashScreenTwo(),
        SplashScreenThree.routName: (context) => SplashScreenThree(),
        SplashScreenFour.routName: (context) => SplashScreenFour(),
        LoginScreen.routName: (context) => LoginScreen(),
        SignupScreen.routName: (context) => SignupScreen(),
        PrivacyPolicyScreen.routName: (context) => PrivacyPolicyScreen(),
        ForgetPasswordScreen.routName: (context) => ForgetPasswordScreen(),
        ConfirmEmailScreen.routName: (context) => ConfirmEmailScreen(),
        ConfirmPasswordScreen.routName: (context) => ConfirmPasswordScreen(),
        CompleteProfileScreen.routName: (context) => CompleteProfileScreen(),
        HomeScreen.routName: (context) => HomeScreen(),
        ProfileScreen.routName: (context) => ProfileScreen(),
        UpdateProfileScreen.routName: (context) => UpdateProfileScreen(),
        ChangePasswordScreen.routName: (context) => ChangePasswordScreen(),
        LessonScreen.routName: (context) => LessonScreen(),

    },
    );
  }
}
