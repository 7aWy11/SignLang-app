import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'confirm_password.dart';

class ConfirmEmailScreen extends StatefulWidget {
  static String routName = 'opt_password';

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController codeController1 = TextEditingController();
  final TextEditingController codeController2 = TextEditingController();
  final TextEditingController codeController3 = TextEditingController();
  final TextEditingController codeController4 = TextEditingController();
  final TextEditingController codeController5 = TextEditingController();
  final TextEditingController codeController6 = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final storage = FlutterSecureStorage();

  String? email;

  @override
  void initState() {
    super.initState();
    _fetchEmail();
  }

  Future<void> _fetchEmail() async {
    String? fetchedEmail = await storage.read(key: "emailForget");
    setState(() {
      email = fetchedEmail;
    });
  }

  void _submitCode() async {
    Navigator.pushNamed(
      context,
      ConfirmPasswordScreen.routName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Confirm Email title
                  Text(
                    'Confirm Code',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (35 / 360),
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A56AC),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (60 / 800)),
                  // Illustration
                  Image.asset(
                    'assets/images/confirm_email_illustration.png',
                    height: MediaQuery.of(context).size.height * (300 / 800),
                    width: MediaQuery.of(context).size.width * (400 / 360),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                  // Instruction Text
                  RichText(
                    text: TextSpan(
                      text: 'We Sent 6 Digits Code To ',
                      style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * (13 / 360)),
                      children: <TextSpan>[
                        TextSpan(
                          text: email ?? "Loading...",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (10 / 800)),
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOtpBox(codeController1, focusNode1, focusNode2),
                      _buildOtpBox(codeController2, focusNode2, focusNode3),
                      _buildOtpBox(codeController3, focusNode3, focusNode4),
                      _buildOtpBox(codeController4, focusNode4, focusNode5),
                      _buildOtpBox(codeController5, focusNode5, focusNode6),
                      _buildOtpBox(codeController6, focusNode6, null),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (5 / 800)),
                  // Resend Code link
                  TextButton(
                    onPressed: () {
                      // Handle resend code
                    },
                    child: Text(
                      "Don't receive code? Re-send",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (5 / 800)),
                  // Submit button
                  ElevatedButton(
                    onPressed: _submitCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A56AC),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (100 / 360),
                        vertical: MediaQuery.of(context).size.height * (15 / 800),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (25 / 360)),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (18 / 360),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(TextEditingController controller, FocusNode focusNode, FocusNode? nextFocusNode) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (40 / 360),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8A56AC)),
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8A56AC)),
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus();
            }
          }
        },
      ),
    );
  }
}
