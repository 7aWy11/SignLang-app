import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:singlanguage/pages/main/camera.dart';
import 'package:singlanguage/pages/lessons/lesson.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../helper/shared.dart';

class DashboardScreen extends StatefulWidget {
  static String routName = 'DashboardScreen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String _currentTime;
  final storage = FlutterSecureStorage();
  String? FirstName;
  String? LastName;
  String? email;
  String? role;
  String? websiteStatus;
  String? aiModelStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _getCurrentTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = _getCurrentTime();
        });
      }
    });
    _fetchUserData();
    _fetchStatuses();
  }

  Future<void> _fetchUserData() async {
    String? fetchedFirstName = await storage.read(key: "first_name");
    String? fetchedLastName = await storage.read(key: "last_name");
    String? fetchedEmail = await storage.read(key: "email");
    String? fetchedRole = await storage.read(key: "role");
    if (mounted) {
      setState(() {
        FirstName = fetchedFirstName;
        LastName = fetchedLastName;
        email = fetchedEmail;
        role = fetchedRole;
      });
    }
  }

  Future<void> _fetchStatuses() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/auth/statuses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (mounted) {
        setState(() {
          websiteStatus = data.firstWhere((element) => element['name'] == 'website')['status'];
          aiModelStatus = data.firstWhere((element) => element['name'] == 'ai_model')['status'];
        });
      }
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  void _launchURL(String URL) async {
    final Uri url = Uri.parse(URL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String _getCurrentTime() {
    return DateFormat('MMMM dd - HH:mm:ss').format(DateTime.now());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * (16 / 800)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * (30 / 800),
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * (10 / 360)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (16 / 800))),
                    Text(
                      '$FirstName $LastName',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.height * (20 / 800), fontWeight: FontWeight.bold),
                    ),
                    Text('Welcome back!', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (16 / 800))),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
            // Camera for Sign Language Card
            GestureDetector(
              onTap: () {
                if (aiModelStatus == null) {
                  showCupertinoDialogReuse(context, "AI Model", 'Failed to get statues');
                } else if (aiModelStatus == 'online') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                } else if (aiModelStatus == 'offline') {
                  showCupertinoDialogReuse(context, "AI Model", 'Sorry our AI Model is now offline try again later.');
                }
                else if (aiModelStatus == 'maintenance') {
                  showCupertinoDialogReuse(context, "AI Model", 'Sorry our AI Model is under maintenance try again later.');
                }


              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (205 / 800),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/card_home.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * (16 / 800)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Camera\nFOR SIGN\nLanguage',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * (20 / 800),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * (30 / 800)),
                            Row(
                              children: [
                                Image.asset(
                                    'assets/images/calendar.png',
                                    width: MediaQuery.of(context).size.width * (40 / 360),
                                    height: MediaQuery.of(context).size.height * (40 / 800)),
                                SizedBox(width: MediaQuery.of(context).size.width * (5 / 360)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_currentTime, style: TextStyle(fontSize: MediaQuery.of(context).size.height * (12 / 800))),
                                    Text('Update Every Monday / Friday', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (12 / 800))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * (13 / 800),
                        right: MediaQuery.of(context).size.width * (16 / 360),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/Frame.png',
                                width: MediaQuery.of(context).size.width * (100 / 360),
                                height: MediaQuery.of(context).size.height * (40 / 800)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                aiModelStatus == null
                                    ? Icon(Icons.downloading_sharp, size: MediaQuery.of(context).size.height * (9 / 800))
                                    : Icon(Icons.circle, color: _getStatusColor(aiModelStatus!), size: MediaQuery.of(context).size.height * (10 / 800)),
                                SizedBox(width: MediaQuery.of(context).size.width * (5 / 360)),
                                Text(aiModelStatus ?? 'Loading', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (9 / 800))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * (9 / 800),
                        right: MediaQuery.of(context).size.width * (-10 / 360),
                        child: Image.asset(
                            'assets/images/camera_home.png',
                            width: MediaQuery.of(context).size.width * (135 / 360),
                            height: MediaQuery.of(context).size.height * (200 / 800)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
            // Lessons and Website Cards
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LessonScreen()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/lessons_background.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height * (16 / 800)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * (170 / 800)),
                                  Text('Lessons',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * (20 / 800),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            // Positioned(
                            //   top: MediaQuery.of(context).size.height * (10 / 800),
                            //   left: 0,
                            //   right: 0,
                            //   child: Stack(
                            //     alignment: Alignment.center,
                            //     children: [
                            //       Image.asset('assets/images/Frame.png',
                            //           width: MediaQuery.of(context).size.width * (300 / 360),
                            //           height: MediaQuery.of(context).size.height * (30 / 800)),
                            //       Text('50 Lessons', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (10 / 800))),
                            //     ],
                            //   ),
                            // ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * (30 / 800),
                              left: MediaQuery.of(context).size.width * (16 / 360),
                              right: MediaQuery.of(context).size.width * (16 / 360),
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/lessons_icon.png',
                                      width: MediaQuery.of(context).size.width * (160 / 360),
                                      height: MediaQuery.of(context).size.height * (160 / 800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * (5 / 360)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (websiteStatus == null) {
                        showCupertinoDialogReuse(context, "Website", 'Failed to get statues');
                      }
                      if (websiteStatus == 'online') {
                        _launchURL('http://10.0.2.2:8000');
                      } else if (websiteStatus == 'offline') {
                        showCupertinoDialogReuse(context, "Website", 'Sorry our website is now offline try again later.');
                      }
                      else if (websiteStatus == 'maintenance') {
                        showCupertinoDialogReuse(context, "Website", 'Sorry our website is under maintenance try again later.');
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/website_background.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height * (16 / 800)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * (170 / 800)),
                                  Text('Website',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height * (20 / 800),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * (10 / 800),
                              left: 0,
                              right: 0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset('assets/images/Frame.png',
                                      width: MediaQuery.of(context).size.width * (170 / 360),
                                      height: MediaQuery.of(context).size.height * (30 / 800)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      websiteStatus == null
                                          ? Icon(Icons.downloading_sharp, size: MediaQuery.of(context).size.height * (9 / 800))
                                          : Icon(Icons.circle, color: _getStatusColor(websiteStatus!), size: MediaQuery.of(context).size.height * (10 / 800)),
                                      SizedBox(width: MediaQuery.of(context).size.width * (5 / 360)),
                                      Text(websiteStatus ?? 'Loading', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (9 / 800))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * (30 / 800),
                              left: MediaQuery.of(context).size.width * (16 / 360),
                              right: MediaQuery.of(context).size.width * (16 / 360),
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/website_icon.png',
                                      width: MediaQuery.of(context).size.width * (160 / 360),
                                      height: MediaQuery.of(context).size.height * (160 / 800)),
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
            SizedBox(height: MediaQuery.of(context).size.height * (10 / 800)),
            // Horizontal Scroll View with Photos, Titles, Descriptions, and Heart Icon with Count
            Container(
              height: MediaQuery.of(context).size.height * (260 / 800),
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
                  SizedBox(height: MediaQuery.of(context).size.height * (100 / 800)),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (85 / 800)),
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
      width: MediaQuery.of(context).size.width * (160 / 360),
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * (10 / 360)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * (8 / 360)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.imagePath,
                  width: double.infinity, height: MediaQuery.of(context).size.height * (100 / 800), fit: BoxFit.cover),
              SizedBox(height: MediaQuery.of(context).size.height * (8 / 800)),
              Text(widget.title,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * (16 / 800), fontWeight: FontWeight.bold)),
              SizedBox(height: MediaQuery.of(context).size.height * (4 / 800)),
              isExpanded
                  ? Text(widget.description, style: TextStyle(fontSize: MediaQuery.of(context).size.height * (14 / 800)))
                  : Text(
                widget.description,
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * (14 / 800)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.description.length > 100)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Read less' : 'Read more...',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * (12 / 800)),
                  ),
                ),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: MediaQuery.of(context).size.height * (16 / 800)),
                  SizedBox(width: MediaQuery.of(context).size.width * (4 / 360)),
                  Text('${widget.heartCount}', style: TextStyle(fontSize: MediaQuery.of(context).size.height * (14 / 800))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
