import 'package:flutter/material.dart';
import '../../pages/auth/otp_password.dart';
import '../../pages/auth/confirm_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';


class ForgetPasswordScreen extends StatefulWidget {
  static String routName = 'ForgotPass';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();


  Future<void> _sendPasswordReset() async {
    if (_formKey.currentState!.validate()) {
      // Proceed with sending password reset message
      await storage.write(key: "emailForget" , value: emailController.text);

      Navigator.pushNamed(
        context,
        ConfirmEmailScreen.routName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Forget Password title
                  Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A56AC),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Illustration
                  Image.asset(
                    'assets/images/forget_password_illustration.png',
                    height: 400,
                    width: 400,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  // Instruction Text
                  Text(
                    'Enter your email to send you a code message',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email Address field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          emailController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your e-mail address";
                      }
                      var regex = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!regex.hasMatch(value)) {
                        return "Invalid e-mail address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Next button
                  ElevatedButton(
                    onPressed: _sendPasswordReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A56AC),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Next',
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
      ),
    );
  }
}
