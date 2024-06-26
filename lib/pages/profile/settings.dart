import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlanguage/pages/profile/change_password.dart';
import 'package:singlanguage/pages/profile/update_profile.dart';

import '../../controllers/auth_controller.dart';
import '../../helper/shared.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<bool> _notificationsStatusFuture;
  String? FirstName;
  String? LastName;
  String? email;
  String? role;
  String? phone;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _notificationsStatusFuture = _getNotificationsStatus();
    _fetchData();
  }

  Future<bool> _getNotificationsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('NotificationsStatus') ?? true;
  }

  Future<void> _toggleNotificationsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool currentStatus = prefs.getBool('NotificationsStatus') ?? true;
    await prefs.setBool('NotificationsStatus', !currentStatus);
  }

  Future<void> _fetchData() async {
    String? fetchedFirstName = await storage.read(key: "first_name");
    String? fetchedLastName = await storage.read(key: "last_name");
    String? fetchedEmail = await storage.read(key: "email");
    String? fetchedRole = await storage.read(key: "role");
    String? fetchedPhone = await storage.read(key: "phone");

    if (mounted) {
      setState(() {
        FirstName = fetchedFirstName;
        LastName = fetchedLastName;
        email = fetchedEmail;
        role = fetchedRole;
        phone = fetchedPhone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _authController = AuthController(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * (250 / 812), // Set a fixed height for the container
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/card_home.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  // Foreground content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(height: 16),
                        Text(
                            FirstName.toString() +
                                " " +
                                LastName.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(email.toString().toUpperCase()),
                      ],
                    ),
                  ),
                  // Pin icon
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle settings tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              trailing: Text('EN - الانجليزيه'),
              onTap: () {
                // Handle language tap
                Get.snackbar('Language', 'Only English language is available, soon we will update our app to support Arabic');
              },
            ),
            FutureBuilder<bool>(
              future: _notificationsStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    trailing: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    trailing: Text("Error"),
                  );
                } else {
                  bool status = snapshot.data ?? true;
                  return ListTile(
                    leading: Icon(status ? Icons.notifications : Icons.notifications_off),
                    title: Text('Notifications'),
                    trailing: Text(status ? "ON" : "OFF"),
                    onTap: () async {
                      await _toggleNotificationsStatus();
                      setState(() {
                        _notificationsStatusFuture = _getNotificationsStatus();
                      });
                      Get.snackbar(
                        'Notifications',
                        status ? 'All Notifications are disabled' : 'All Notifications are allowed',
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.headphones),
              title: Text('Help and Feedback'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle help and feedback tap

              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                MessageBoxonConfirm(context, "Log out",
                    "Are you sure you want to log out?", () {
                      _authController.logout();
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
