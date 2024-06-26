import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:singlanguage/pages/splash/screen_1.dart';
import 'services/app_routes.dart';

List<CameraDescription>? cameras;

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
      initialRoute: SplashScreen.routeName,
      routes: AppRoutes.routes,
    );
  }
}
