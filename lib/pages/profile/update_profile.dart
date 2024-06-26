import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:singlanguage/controllers/auth_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  static String routeName = 'update_profile';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _authController = null;
  String? FirstName;
  String? LastName;
  String? email;
  String? role;
  String? phone;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? fetchedFirstName = await storage.read(key: "first_name");
    String? fetchedLastName = await storage.read(key: "last_name");
    String? fetchedPhone = await storage.read(key: "phone");

    setState(() {
      firstNameController.text = fetchedFirstName.toString();
      lastNameController.text = fetchedLastName.toString();
      phoneNumberController.text = fetchedPhone.toString();
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _authController.updateProfile(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          phoneNumberController.text.trim(),
          false);
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
                      'Update your profile',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (30 / 360),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A56AC),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (5 / 800)),
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
                      'Update your personal information, to be reliability with your ID.',
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
                        labelText: 'First Name',
                        hintText: FirstName.toString(),
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
                        labelText: 'Last Name',
                        hintText: LastName.toString(),
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
                        labelText: 'Phone Number',
                        hintText: phone.toString(),
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
