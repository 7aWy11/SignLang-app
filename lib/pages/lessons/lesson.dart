import 'package:flutter/material.dart';
import 'lesson_view.dart';

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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (24 / 800)),
            Text(
              'Sign Language Guide',
              style: TextStyle(
                color: Color(0xFF8A56AC),
                fontSize: MediaQuery.of(context).size.width * (24 / 360),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (15 / 800)),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: MediaQuery.of(context).size.width * (16 / 360),
                  mainAxisSpacing: MediaQuery.of(context).size.height * (16 / 800),
                  childAspectRatio: (160 / 2) / (280 / 2), // Adjust according to your aspect ratio
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> lessons = [
                    {
                      'imagePath': 'assets/images/headphone.png',
                      'lessonCount': '30 lessons',
                      'title': 'TOP 30 SIGNS',
                      'color': Color(0xFFE5F4FD),
                      'lessonName': 'Top 30 Signs'
                    },
                    {
                      'imagePath': 'assets/images/heart.png',
                      'lessonCount': '7 lessons',
                      'title': 'Feelings',
                      'color': Color(0xFFFDE7EB),
                      'lessonName': 'Feelings'
                    },
                    {
                      'imagePath': 'assets/images/camera.png',
                      'lessonCount': '4 lessons',
                      'title': 'Actions',
                      'color': Color(0xFFFDF8C9),
                      'lessonName': 'Actions'
                    },
                    {
                      'imagePath': 'assets/images/amb.png',
                      'lessonCount': '8 lessons',
                      'title': 'Weather',
                      'color': Color(0xFFE7ECF1),
                      'lessonName': 'Weather'
                    },
                  ];
                  return _buildLessonCard(
                    context,
                    lessons[index]['imagePath'],
                    lessons[index]['lessonCount'],
                    lessons[index]['title'],
                    lessons[index]['color'],
                    lessons[index]['lessonName'],
                  );
                },
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
      String lessonName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LessonView(lessonName: lessonName)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (12 / 360)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: MediaQuery.of(context).size.width * (4 / 360),
              blurRadius: MediaQuery.of(context).size.width * (5 / 360),
              offset: Offset(0, MediaQuery.of(context).size.height * (3 / 800)),
            ),
          ],
        ),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * (200 / 800),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MediaQuery.of(context).size.width * (12 / 360)),
                  topRight: Radius.circular(MediaQuery.of(context).size.width * (12 / 360)),
                ),
              ),
              child: Center(
                child: Image.asset(imagePath, height: MediaQuery.of(context).size.height * (100 / 800)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * (8 / 360)),
              child: Text(
                lessonCount,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (16 / 360),
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * (8 / 360),
                vertical: MediaQuery.of(context).size.height * (4 / 800),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (18 / 360),
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
