import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showCupertinoDialogReuse(
  BuildContext context,
  String title,
  String message,
) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void MessageBoxonConfirm(
    BuildContext context, String title, String content, Function onConfirm) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}


double getProportionateScreenWidth(BuildContext context, double inputWidth) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designers use
  return (inputWidth / 375.0) * screenWidth;
}

double getProportionateScreenHeight(BuildContext context, double inputHeight) {
  double screenHeight = MediaQuery.of(context).size.height;
  // 812 is the layout height that designers use
  return (inputHeight / 812.0) * screenHeight;
}
