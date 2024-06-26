import 'package:flutter/material.dart';
import '../../pages/auth/otp_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String routeName = 'ForgotPass';

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
      await storage.write(key: "emailForget", value: emailController.text);

      Navigator.pushNamed(
        context,
        ConfirmEmailScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
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
                        fontSize: MediaQuery.of(context).size.width * (30 / 360),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A56AC),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Illustration
                    Image.asset(
                      'assets/images/forget_password_illustration.png',
                      height: MediaQuery.of(context).size.height * (400 / 800),
                      width: MediaQuery.of(context).size.width * (400 / 360),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Instruction Text
                    Text(
                      'Enter your email to send you a code message',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (16 / 360),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
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
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Next button
                    ElevatedButton(
                      onPressed: _sendPasswordReset,
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
                        'Next',
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
      ),
    );
  }
}
