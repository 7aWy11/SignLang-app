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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                //leading: Icon(Icons.arrow_back_ios),
                title: Text(
                  '$lessonName - $title',
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * (18 / 360)),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: MediaQuery.of(context).size.width * (24 / 360)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              Image.asset(imagePath, height: MediaQuery.of(context).size.height * (200 / 800), fit: BoxFit.cover),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              Text(
                title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (30 / 360),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              Text(
                description,
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * (13 / 360)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
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
                    Text(
                      'Watch video',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * (16 / 360)),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * (8 / 360)),
                    Icon(Icons.play_arrow, size: MediaQuery.of(context).size.width * (24 / 360)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (32 / 360),
                    vertical: MediaQuery.of(context).size.height * (12 / 800),
                  ),
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
