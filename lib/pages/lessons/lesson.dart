import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lesson_view.dart';

class LessonScreen extends StatefulWidget {
  static String routName = 'LessonScreen';

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<Map<String, dynamic>> lessons = [];
  bool isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    fetchLessonData();
  }

  Future<void> fetchLessonData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/auth/guides/count/category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        lessons = data.map((item) {
          return {
            'lessonName': item['category'],
            'lessonCount': '${item['count']} lessons',
            'imagePath': getImagePath(item['category']),
            'color': getColor(item['category']),
            'title': getTitle(item['category']),
          };
        }).toList();
        isLoading = false; // Set loading to false when data is fetched
      });
    } else {
      throw Exception('Failed to load lesson data');
    }
  }

  String getImagePath(String category) {
    switch (category.toLowerCase()) {
      case 'feeling':
        return 'assets/images/heart.png';
      case 'actions':
        return 'assets/images/camera.png';
      case 'weather':
        return 'assets/images/amb.png';
      default:
        return 'assets/images/headphone.png';
    }
  }

  Color getColor(String category) {
    switch (category.toLowerCase()) {
      case 'feeling':
        return Color(0xFFFDE7EB);
      case 'actions':
        return Color(0xFFFDF8C9);
      case 'weather':
        return Color(0xFFE7ECF1);
      default:
        return Color(0xFFE5F4FD);
    }
  }

  String getTitle(String category) {
    switch (category.toLowerCase()) {
      case 'feeling':
        return 'Feelings';
      case 'actions':
        return 'Actions';
      case 'weather':
        return 'Weather';
      default:
        return 'TOP 30 SIGNS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
        child: isLoading // Check if data is still loading
            ? Center(child: CircularProgressIndicator()) // Show progress indicator
            : Column(
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
                  childAspectRatio: (160 / 2) / (280 / 2),
                ),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
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
      String lessonName,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonView(lessonName: lessonName),
          ),
        );
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
