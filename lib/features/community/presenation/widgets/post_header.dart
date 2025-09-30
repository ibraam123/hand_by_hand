import 'package:flutter/material.dart';

import '../../../../core/services/tts_service.dart';

class PostHeader extends StatefulWidget {
  final String title;
  final String email;
  final String date;

  const PostHeader({
    super.key,
    required this.title,
    required this.email,
    required this.date,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  late TTSService tts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tts = TTSService("en-US");
  }

  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  void _speakText(String text) async {
    final isAr = _isArabic(text);

    // reconfigure TTS based on language
    await tts.setLanguage(isAr ? "ar-SA" : "en-US");
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.blue),
              onPressed: () => _speakText(widget.title),
            ),
          ],
        ),
        Text(
          "${widget.email} • ${widget.date}",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
