import 'package:flutter/material.dart';
import 'lesson_details.dart';

class LessonView extends StatefulWidget {
  static const routName = 'LessonViewScreen';

  final String lessonName;

  LessonView({required this.lessonName});

  @override
  _LessonViewScreenState createState() => _LessonViewScreenState();
}

class _LessonViewScreenState extends State<LessonView> {
  final List<Map<String, String>> lessons = List.generate(30, (index) => {
    'title': 'Lesson ${index + 1}',
    'description': 'Description of Lesson ${index + 1}. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson.',
    'image': 'assets/images/photo2.png',
    'videoUrl': 'https://www.youtube.com/watch?v=5jVnLbdqR6U',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.arrow_back_ios, size: MediaQuery.of(context).size.width * (24 / 360)),
              title: Text(
                widget.lessonName,
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * (18 / 360)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  return _buildLessonCard(
                    widget.lessonName,
                    lessons[index]['image']!,
                    lessons[index]['title']!,
                    lessons[index]['description']!,
                    lessons[index]['videoUrl']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(String lessonName, String imagePath, String title, String description, String videoUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetails(
              lessonName: lessonName,
              imagePath: imagePath,
              title: title,
              description: description,
              videoUrl: videoUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * (16 / 800)),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (12 / 360)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: MediaQuery.of(context).size.height * (80 / 800), width: MediaQuery.of(context).size.width * (80 / 360), fit: BoxFit.cover),
            SizedBox(width: MediaQuery.of(context).size.width * (16 / 360)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * (18 / 360),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: MediaQuery.of(context).size.width * (18 / 360)),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (8 / 800)),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * (14 / 360), color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonDetails(
                            lessonName: lessonName,
                            imagePath: imagePath,
                            title: title,
                            description: description,
                            videoUrl: videoUrl,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Read more',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * (14 / 360), color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
