import 'package:flutter/material.dart';
import 'package:singlanguage/controllers/auth_controller.dart';
import 'package:singlanguage/pages/auth/login.dart';

import '../../helper/shared.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routName = 'complete_profile';

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _authController = null;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _authController.updateProfile(firstNameController.text.trim(),
          lastNameController.text.trim(), phoneNumberController.text.trim());
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
                  // Complete Profile title
                  Text(
                    'Complete your profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A56AC),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Illustration
                  Image.asset(
                    'assets/images/complete_profile_illustration.png',
                    height: 350,
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  // Instruction Text
                  Text(
                    'Here after sign up, Please complete your personal data to use our application.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // First Name field
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'First name',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          firstNameController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your first name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Last Name field
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      hintText: 'Last name',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          lastNameController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your last name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Phone Number field
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone No.',
                      hintText: 'Phone No.',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          phoneNumberController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You must enter your phone number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Update button
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A56AC),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Update',
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
