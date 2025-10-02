import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SignLanguageLessonVideoScreen extends StatefulWidget {
  const SignLanguageLessonVideoScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.description,
  });

  final String videoUrl;
  final String title;
  final String? description;

  @override
  State<SignLanguageLessonVideoScreen> createState() =>
      _SignLanguageLessonVideoScreenState();
}

class _SignLanguageLessonVideoScreenState
    extends State<SignLanguageLessonVideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Sign Language Video" , style: TextStyle(color: Theme.of(context).colorScheme.onSurface , fontWeight: FontWeight.bold), ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎥 Video Player
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  ),
                ),
                const SizedBox(height: 20),

                // 📖 Lesson Title
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),

                // 📝 Lesson Description (if available)
                if (widget.description != null &&
                    widget.description!.isNotEmpty)
                  Text(
                    widget.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
