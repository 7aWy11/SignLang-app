import 'package:flutter/material.dart';

class LessonDetails extends StatelessWidget {
  static const routName = 'LessonDetails';

  final String lessonName;
  final String imagePath;
  final String title;
  final String description;
  final String videoUrl;

  LessonDetails({
    required this.lessonName,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                //leading: Icon(Icons.arrow_back_ios),
                title: Text('$lessonName - $title' ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
              Image.asset(imagePath, height: 200, fit: BoxFit.cover),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle video playback
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Watch video'),
                    SizedBox(width: 8),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // Implement your video player here
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        child: Text('Video player for $videoUrl'),
      ),
    );
  }
}
