import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlanguage/controllers/auth_controller.dart';
import 'package:singlanguage/pages/auth/login.dart';
import 'package:singlanguage/pages/main/complete_profile.dart';
import 'package:singlanguage/pages/main/home.dart';
import 'package:singlanguage/pages/profile/update_profile.dart';
import 'dart:async';
import 'package:singlanguage/pages/splash/screen_2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routName = 'SplashView';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _authController = null;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      prefs.setBool('isFirstRun', false);
      Timer(
        const Duration(seconds: 4),
        () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SplashScreenTwo(),
            ),
          );
        },
      );
    } else {
      Timer(
        const Duration(seconds: 4),
        () async {
          if (!mounted) return;

          if (await _authController.isAuthed()) {

            try{
              await _authController.getStatuses();
              dynamic data = await _authController.getUserData();
              if (data['first_name'] == null || data['last_name'] == null || data['phone'] == null)
                Navigator.pushReplacementNamed(context, CompleteProfileScreen.routName);
              else
                Navigator.pushReplacementNamed(context, HomeScreen.routName);
            }
            catch (e)
            {
              Navigator.pushReplacementNamed(context, CompleteProfileScreen.routName);
              print(e);
            }
          } else {
            dynamic data = await _authController.getUserData();
            Navigator.pushReplacementNamed(context, LoginScreen.routName);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _authController = AuthController(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeInUp(
          duration: const Duration(seconds: 3),
          child: Image.asset(
            'assets/icons/logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
