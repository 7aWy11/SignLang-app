import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singlanguage/controllers/auth_controller.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/shared.dart';
import '../auth/login.dart';

class HomeScreen extends StatefulWidget {
  static String routName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _currentTime;

  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController();
  var _authController = null;
  final storage = FlutterSecureStorage();

  String? FirstName;
  String? LastName;
  String? email;
  String? role;


  @override
  void initState() {
    super.initState();
    _currentTime = _getCurrentTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime();
      });
    });
  }

  Future<void> _fetchData() async {
    String? fetchedFirstName = await storage.read(key: "first_name");
    String? fetchedLastName = await storage.read(key: "last_name");
    String? fetchedEmail = await storage.read(key: "email");
    String? fetchedRole = await storage.read(key: "role");
    setState(() {

      FirstName = fetchedFirstName;
      LastName = fetchedLastName;
      email = fetchedEmail;
      role = fetchedRole;

    });
  }
  void _jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }




  _launchURL(String URL) async {
    final Uri url = Uri.parse(URL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // Future<void> checkUserRole()async {
  //   if (role == "banned")
  //     showCupertinoDialogReuse(context , "user manager: checking role ", "Administrator give you banned now! go out");
  //     //Navigator.pushReplacementNamed(context, LoginScreen.routName);
  //   }

  String _getCurrentTime() {
    return DateFormat('MMMM dd - HH:mm:ss').format(DateTime.now());
  }



/*
* AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        pageController: _pageController,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: Colors.blueGrey),
            activeItem: Icon(Icons.home_filled, color: Colors.blueAccent),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.play_lesson, color: Colors.blueGrey),
            activeItem: Icon(Icons.play_lesson, color: Colors.blueAccent),
            itemLabel: 'Lessons',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.blueGrey),
            activeItem: Icon(Icons.person, color: Colors.blueAccent),
            itemLabel: 'Profile',
          ),
        ],
        removeMargins: true,
        bottomBarWidth: 500.0,
        bottomBarHeight: 62.0,
        durationInMilliSeconds: 300,
        showLabel: true,
        itemLabelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        notchColor: Colors.black87,
        showBottomRadius: false,
        showTopRadius: false,
        elevation: 2.0,
        showBlurBottomBar: true,
        blurOpacity: 0.2,
        blurFilterX: 5.0,
        blurFilterY: 10.0, onTap: (int value) {  }, kIconSize: 1, kBottomRadius: 1,
      )*/

  @override
  Widget build(BuildContext context) {
    _authController = AuthController(context);
    _fetchData();
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          height: 90,
          child: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,
            color: Colors.white,
            showLabel: true,
            textOverflow: TextOverflow.visible,
            maxLine: 1,
            shadowElevation: 10,
            kBottomRadius: 15.0,
            removeMargins: false,
            bottomBarWidth: 300,
            showShadow: true,
            durationInMilliSeconds: 200,
            itemLabelStyle: const TextStyle(fontSize: 10),
            elevation: 1,
            bottomBarItems: const [
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.home_filled,
                  color: Colors.blueGrey,
                ),
                activeItem: Icon(
                  Icons.home_filled,
                  color: Colors.purple,
                ),
                itemLabel: 'Home',
              ),
              BottomBarItem(
                inActiveItem: Icon(Icons.star, color: Colors.blueGrey),
                activeItem: Icon(
                  Icons.star,
                  color: Colors.purple,
                ),
                itemLabel: 'Blogs',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.settings,
                  color: Colors.blueGrey,
                ),
                activeItem: Icon(
                  Icons.settings,
                  color: Colors.purple,
                ),
                itemLabel: 'Profile',
              ),
            ],
            onTap: (index) {
              _jumpToPage(index);
            },
            kIconSize: 24.0,
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(), // Disable swiping
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.0266),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello', style: TextStyle(fontSize: 16)),
                            Text(FirstName.toString() + " " + LastName.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Welcome back!',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.0246),

                    // Camera for Sign Language Card
                    GestureDetector(
                      onTap: (){
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/card_home.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Camera\nFOR SIGN\nLanguage',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Image.asset('assets/images/calendar.png',
                                            width: 40, height: 40),
                                        SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(_currentTime!,
                                                style: TextStyle(fontSize: 16)),
                                            Text('Update Every Monday / Friday',
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 13,
                                right: 16,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/Frame.png',
                                        width: 100, height: 40),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.circle,
                                            color: Colors.green, size: 10),
                                        SizedBox(width: 5),
                                        Text('Online',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 25,
                                right: -20,
                                child: Image.asset('assets/images/camera_home.png',
                                    width: 180, height: 180),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Lessons and Website Cards
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: ()
                            {

                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/lessons_background.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 170),
                                          Text('Lessons',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      right: 0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset('assets/images/Frame.png',
                                              width: 300, height: 30),
                                          Text('50 Lessons',
                                              style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      left: 16,
                                      right: 16,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                              'assets/images/lessons_icon.png',
                                              width: 160, height: 160),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: ()
                            {
                              _launchURL('http://10.0.2.2:8000');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/website_background.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 170),
                                          Text('Website',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      right: 0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset('assets/images/Frame.png',
                                              width: 170, height: 30),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.circle,
                                                  color: Colors.green, size: 10),
                                              SizedBox(width: 5),
                                              Text('Online',
                                                  style: TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      left: 16,
                                      right: 16,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                              'assets/images/website_icon.png',
                                              width: 160, height: 160),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Horizontal Scroll View with Photos, Titles, Descriptions, and Heart Icon with Count
                    Container(
                      height: 260,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CustomCard(
                            imagePath: 'assets/images/photo1.png',
                            title: 'Happy',
                            description:
                            'To sign "happy," rotate 1 or 2 hands in front of your chest. To sign "happy," rotate 1 or 2 hands in front of your chest. To sign "happy," rotate 1 or 2 hands in front of your chest.',
                            heartCount: 10,

                          ),
                          CustomCard(
                            imagePath: 'assets/images/photo2.png',
                            title: 'Sad',
                            description:
                            'To sign "sad," drag both hands down your face like tears.',
                            heartCount: 20,
                          ),
                          CustomCard(
                            imagePath: 'assets/images/photo3.png',
                            title: 'Angry or mad',
                            description:
                            'To sign "angry" or "mad," scrunch your hand in front of your face.',
                            heartCount: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: Text('Lesson Page')),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  MessageBoxonConfirm(context, "Log out",
                      "Are you sure you want to log out?", () {
                        _authController.logout();
                      });
                },
                child: Text('Logout!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final int heartCount;

  CustomCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.heartCount,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.imagePath,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover),
              SizedBox(height: 8),
              Text(widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              isExpanded
                  ? Text(widget.description, style: TextStyle(fontSize: 14))
                  : Text(
                widget.description,
                style: TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.description.length > 100)
                Text(
                  isExpanded ? 'Read less' : 'Read more...',
                ),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text('${widget.heartCount}', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}