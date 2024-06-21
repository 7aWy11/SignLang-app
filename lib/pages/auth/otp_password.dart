import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pages/auth/confirm_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



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
    await storage.delete(key: "emailForget");
    // Handle code submission
    // Navigator.pushNamed(
    //   context,
    //   ConfirmPasswordScreen.routName,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Confirm Email title
                Text(
                  'Confirm Your Email',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A56AC),
                  ),
                ),
                SizedBox(height: 60),
                // Illustration
                Image.asset(
                  'assets/images/confirm_email_illustration.png',
                  height: 400,
                  width: 400,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                // Instruction Text
                RichText(
                  text: TextSpan(
                    text: 'We Sent 6 Digits Code To ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: email ?? "Loading...",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                // Submit button
                ElevatedButton(
                  onPressed: _submitCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A56AC),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(TextEditingController controller, FocusNode focusNode,
      FocusNode? nextFocusNode) {
    return SizedBox(
      width: 40,
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
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8A56AC)),
            borderRadius: BorderRadius.circular(8.0),
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
