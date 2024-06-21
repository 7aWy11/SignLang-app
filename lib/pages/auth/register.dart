import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:singlanguage/controllers/auth_controller.dart';
import '../../helper/shared.dart';
import '../../pages/main/complete_profile.dart';
import '../../pages/auth/login.dart';
import '../../pages/main/privacy_and_policy.dart';

class SignupScreen extends StatefulWidget {
  static String routName = 'SignUp';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool agreeToTerms = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  final _formKey = GlobalKey<FormState>();
  var _authController = null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      if (!agreeToTerms) {
        showSnackBar(
            context,
            'Please accept the terms of service and privacy policy.',
            Colors.red);
        return;
      }

      _authController.register(
          emailController.text.trim(), passwordController.text.trim());

      // AuthResult result = await _apiService.register(
      //     emailController.text.trim(), passwordController.text.trim());
      //
      // if (result.success) {
      //   showSnackBar(context, 'Your account has been created successfully.',
      //       Colors.green);
      //   Navigator.pushNamed(context, CompleteProfileScreen.routName);
      // } else {
      //   showSnackBar(context, result.message, Colors.red);
      // }
    }
  }

  void _goToPrivacyPolicy() {
    // Navigate to the Privacy Policy screen
    Navigator.pushNamed(
      context,
      PrivacyPolicyScreen.routName,
    );
  }

  void _goToLogin() {
    // Navigate to the Login screen
    Navigator.pushNamed(
      context,
      LoginScreen.routName,
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
            child: SlideTransition(
              position: _animation,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Signup title
                    Text(
                      'SIGNUP',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Illustration
                    Image.asset(
                      'assets/images/signup_illustration.png',
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
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
                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                        var regex = RegExp(
                            r"(?=^.{8,}$)(?=.*[!@#$%^&*]+)(?!.*\n)(?=.*[A-Z])(?=.*[a-z]).*$");
                        if (!regex.hasMatch(value)) {
                          return "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Confirm Password field
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must confirm your password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Terms of Service checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: Colors.purple,
                          checkColor: Colors.white,
                          value: agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I AGREE TO THE ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'TERMS OF SERVICE',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _goToPrivacyPolicy,
                                ),
                                TextSpan(
                                  text: ' AND ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'PRIVACY POLICY',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _goToPrivacyPolicy,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Signup button
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8A56AC),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Sign in link
                    Text.rich(
                      TextSpan(
                        text: 'Already Have Account? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In.',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _goToLogin,
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
