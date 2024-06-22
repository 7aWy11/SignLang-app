import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../helper/shared.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String routName = 'change_password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currnetpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController newconfirmPasswordController = TextEditingController();
  bool _currentpasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _newconfirmPasswordVisible = false;
  var _authController = null;
  final _formKey = GlobalKey<FormState>();

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      // Proceed with password confirmation

      _authController.changePassword(currnetpasswordController.text,
          newconfirmPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authController = AuthController(context);
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
                  // Confirm Password title
                  Text(
                    'Change password',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A56AC),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Illustration
                  Image.asset(
                    'assets/images/confirm_password_illustration.png',
                    height: 400,
                    width: 400,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  // Current Password field
                  TextFormField(
                    controller: currnetpasswordController,
                    obscureText: !_currentpasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _currentpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentpasswordVisible = !_currentpasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your current password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // New Password field
                  TextFormField(
                    controller: newpasswordController,
                    obscureText: !_newPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _newPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _newPasswordVisible = !_newPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your new password";
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
                  // Confirm New Password field
                  TextFormField(
                    controller: newconfirmPasswordController,
                    obscureText: !_newconfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _newconfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _newconfirmPasswordVisible = !_newconfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must confirm your new password";
                      }
                      if (value != newpasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Confirm button
                  ElevatedButton(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A56AC),
                      padding:
                      EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Confirm',
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
