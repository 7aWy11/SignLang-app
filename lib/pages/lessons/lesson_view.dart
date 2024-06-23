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
    'description': 'Description of Lesson ${index + 1}. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson. This is a detailed description explaining the lesson.',
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
              leading: Icon(Icons.arrow_back_ios),
              title: Text(widget.lessonName),
              //trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
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
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(16.0),
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
        child: Row(
          children: [
            Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(width: 16),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      style: TextStyle(fontSize: 14, color: Colors.blue),
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
