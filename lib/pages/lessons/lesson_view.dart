import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lesson_details.dart';

class LessonView extends StatefulWidget {
  static const routName = 'LessonViewScreen';

  final String lessonName;

  LessonView({required this.lessonName});

  @override
  _LessonViewScreenState createState() => _LessonViewScreenState();
}

class _LessonViewScreenState extends State<LessonView> {
  late Future<List<Map<String, dynamic>>> lessonsFuture;

  @override
  void initState() {
    super.initState();
    lessonsFuture = fetchLessons();
  }

  Future<List<Map<String, dynamic>>> fetchLessons() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/auth/guides/category/${widget.lessonName}'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => {
        'title': item['name'],
        'description': item['description'],
        'image': 'http://10.0.2.2:8000/storage/' + item['image'],
        'videoUrl': item['video_url'],
      }).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: lessonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load lessons'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No lessons available'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final lesson = snapshot.data![index];
                      final imagePath = lesson['image'];
                      final title = lesson['title'];
                      final description = lesson['description'];
                      final videoUrl = lesson['videoUrl'];

                      return _buildLessonCard(
                        widget.lessonName,
                        imagePath,
                        title,
                        description,
                        videoUrl,
                      );
                    },
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
            SizedBox(
              height: MediaQuery.of(context).size.height * (80 / 800),
              width: MediaQuery.of(context).size.width * (80 / 360),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                headers: {
                  'Cache-Control': 'no-cache',
                  'Pragma': 'no-cache',
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: MediaQuery.of(context).size.width * (80 / 360));
                },
              ),
            ),
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
