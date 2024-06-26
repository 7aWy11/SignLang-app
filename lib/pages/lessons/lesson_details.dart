import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonDetails extends StatefulWidget {
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
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  bool _isVideoPlaying = false;

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
                title: Text(
                  '${widget.lessonName} - ${widget.title}',
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * (18 / 360)),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: MediaQuery.of(context).size.width * (24 / 360)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              _isVideoPlaying
                  ? YoutubePlayerWidget(videoUrl: widget.videoUrl)
                  : Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    widget.imagePath,
                    height: MediaQuery.of(context).size.height * (200 / 800),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_circle_fill, size: 64.0, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _isVideoPlaying = true;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (30 / 360),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (16 / 800)),
              Text(
                widget.description,
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * (13 / 360)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (20 / 800)),
            ],
          ),
        ),
      ),
    );
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  YoutubePlayerWidget({required this.videoUrl});

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      onReady: () {
        print('Player is ready.');
      },
    );
  }
}
