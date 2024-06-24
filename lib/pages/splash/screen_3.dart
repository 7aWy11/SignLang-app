import 'package:flutter/material.dart';
import 'package:singlanguage/pages/splash/screen_4.dart';

class SplashScreenThree extends StatefulWidget {
  static String routName = 'SplashViewThree';

  @override
  _SplashScreenThreeState createState() => _SplashScreenThreeState();
}

class _SplashScreenThreeState extends State<SplashScreenThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SplashScreenFour(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image or Illustration
                Image.asset(
                  'assets/images/Frame 427319827.png',
                  height: MediaQuery.of(context).size.height * (350 / 800),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * (20 / 800)),
                // Description Text
                Text(
                  'SLR is free Community Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * (18 / 360),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * (30 / 800)),
                // Continue Button
                ElevatedButton(
                  onPressed: _navigateToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A56AC), // Button color
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * (50 / 360),
                      vertical: MediaQuery.of(context).size.height * (15 / 800),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * (25 / 360)),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (18 / 360),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * (20 / 800)),
                // Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildDot(false),
                    _buildDot(true),
                    _buildDot(false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (4 / 360)),
      height: MediaQuery.of(context).size.height * (10 / 800),
      width: isActive
          ? MediaQuery.of(context).size.width * (55 / 360)
          : MediaQuery.of(context).size.width * (35 / 360),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF8A56AC) : Colors.grey,
        borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * (5 / 360)),
      ),
    );
  }
}
