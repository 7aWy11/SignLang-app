import 'package:flutter/material.dart';
import 'package:singlanguage/controllers/auth_controller.dart';

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
      _authController.updateProfile(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        phoneNumberController.text.trim(),
        true,
      );
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
                    // Complete Profile title
                    Text(
                      'Complete your profile',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (30 / 360),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A56AC),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Illustration
                    Image.asset(
                      'assets/images/complete_profile_illustration.png',
                      height: MediaQuery.of(context).size.height * (280 / 800),
                      width: MediaQuery.of(context).size.width * (400 / 360),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Instruction Text
                    Text(
                      'Here after sign up, Please complete your personal data to use our application.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (16 / 360),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must enter your first name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must enter your last name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (8 / 360)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "You must enter your phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
                    // Update button
                    ElevatedButton(
                      onPressed: _updateProfile,
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
                        'Update',
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
