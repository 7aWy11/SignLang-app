import 'package:flutter/material.dart';

class LessonScreen extends StatefulWidget {
  static String routName = 'LessonScreen';

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              'Sign Language Guide',
              style: TextStyle(
                color: Color(0xFF2B2D30),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 120),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildLessonCard(
                    context,
                    'assets/images/headphone.png',
                    '30 lessons',
                    'TOP 30 SIGNS',
                    Color(0xFFE5F4FD),
                    Top30SignsScreen(),
                    height: 250,
                  ),
                  _buildLessonCard(
                    context,
                    'assets/images/heart.png',
                    '7 lessons',
                    'Feelings',
                    Color(0xFFFDE7EB),
                    FeelingsScreen(),
                  ),
                  _buildLessonCard(
                    context,
                    'assets/images/camera.png',
                    '4 lessons',
                    'Actions',
                    Color(0xFFFDF8C9),
                    ActionsScreen(),
                  ),
                  _buildLessonCard(
                    context,
                    'assets/images/amb.png',
                    '8 lessons',
                    'Weather',
                    Color(0xFFE7ECF1),
                    WeatherScreen(),
                  ),
                 ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(
      BuildContext context,
      String imagePath,
      String lessonCount,
      String title,
      Color color,
      Widget screen, {
        double? height ,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120 , // Adjust height proportionally
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Image.asset(imagePath, height: 80), // Adjust image size proportionally
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lessonCount,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Top30SignsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top 30 Signs')),
      body: Center(child: Text('Top 30 Signs Content')),
    );
  }
}

class FeelingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feelings')),
      body: Center(child: Text('Feelings Content')),
    );
  }
}

class ActionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actions')),
      body: Center(child: Text('Actions Content')),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Center(child: Text('Weather Content')),
    );
  }
}
