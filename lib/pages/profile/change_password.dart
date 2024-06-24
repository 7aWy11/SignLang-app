import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

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
                    // Confirm Password title
                    Text(
                      'Change password',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (30 / 360),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A56AC),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Illustration
                    Image.asset(
                      'assets/images/change_password_illustration.png',
                      height: MediaQuery.of(context).size.height * (300 / 800),
                      width: MediaQuery.of(context).size.width * (400 / 360),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must enter your current password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
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
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
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
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Confirm button
                    ElevatedButton(
                      onPressed: _updatePassword,
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
                        'Confirm',
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
