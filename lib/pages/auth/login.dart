import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:singlanguage/controllers/auth_controller.dart';
import 'package:singlanguage/pages/auth/forget_password.dart';
import 'package:singlanguage/pages/auth/register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../main/home.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  var _authController = null;
  final storage = FlutterSecureStorage();
  String? token;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    //getToken();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    String? fetchedtoken = await storage.read(key: "token");

    setState(() {
      token = fetchedtoken;
    });
    if (token != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      print("don't have token!");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  void _login() async {
    if (_formKey.currentState!.validate()) {
      _authController.login(
          emailController.text.trim(), passwordController.text.trim());
    }
  }

  void _goToForgotPassword() {
    // Navigate to the Forgot Password screen
    Navigator.pushNamed(
      context,
      ForgetPasswordScreen.routeName,
    );
  }

  void _goToSignUp() {
    // Navigate to the Sign Up screen
    Navigator.pushNamed(
      context,
      SignupScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    _authController = AuthController(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Login title
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF8A56AC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Illustration
                    Image.asset(
                      'assets/images/login_illustration.png',
                      height: MediaQuery.of(context).size.height * (300 / 812),
                      width: MediaQuery.of(context).size.width * (400 / 375),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Email Address field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email address',
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
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Your password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must enter your password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (10 / 812)),
                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _goToForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Login button
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8A56AC),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // // Social login buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //       icon: Image.asset('assets/images/GOOGLE.png'),
                    //       iconSize: 20,
                    //       onPressed: () {
                    //         // Handle Google login
                    //       },
                    //     ),
                    //     SizedBox(width: MediaQuery.of(context).size.width * (10 / 812)),
                    //     IconButton(
                    //       icon: Image.asset('assets/images/APPLE.png'),
                    //       iconSize: 20,
                    //       onPressed: () {
                    //         // Handle Apple login
                    //       },
                    //     ),
                    //     SizedBox(width: MediaQuery.of(context).size.width * (1 / 812)),
                    //     IconButton(
                    //       icon: Image.asset('assets/images/FACEBOOK.png'),
                    //       iconSize: 20,
                    //       onPressed: () {
                    //         // Handle Facebook login
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
                    // Sign up link
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _goToSignUp,
                          ),
                        ],
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
