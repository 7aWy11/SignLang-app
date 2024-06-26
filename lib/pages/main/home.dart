import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:singlanguage/pages/main/camera.dart';
import 'package:singlanguage/pages/main/dashboard.dart';
import 'package:singlanguage/pages/profile/settings.dart';
import 'package:singlanguage/pages/lessons/lesson.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController();

  void _jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          child: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,
            color: Colors.white,
            showLabel: true,
            textOverflow: TextOverflow.visible,
            maxLine: 1,
            shadowElevation: 10,
            kBottomRadius: 15.0,
            removeMargins: false,
            bottomBarWidth: MediaQuery.of(context).size.width * (5 / 360),
            showShadow: true,
            durationInMilliSeconds: 200,
            itemLabelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * (10 / 800)),
            elevation: 1,
            bottomBarItems: [
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
                inActiveItem: Icon(Icons.menu_book_outlined, color: Colors.blueGrey),
                activeItem: Icon(
                  Icons.menu_book_outlined,
                  color: Colors.purple,
                ),
                itemLabel: 'Lessons',
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
            kIconSize: MediaQuery.of(context).size.height * (18 / 800),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            DashboardScreen(),
            LessonScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
