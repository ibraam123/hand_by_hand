import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/services/tts_service.dart';
import '../../../data/models/role_model.dart';

class RoleModelDetailsScreen extends StatefulWidget {
  final RoleModel roleModel;

  const RoleModelDetailsScreen({super.key, required this.roleModel});

  @override
  State<RoleModelDetailsScreen> createState() => _RoleModelDetailsScreenState();
}

class _RoleModelDetailsScreenState extends State<RoleModelDetailsScreen> {
  late TTSService tts;

  @override
  void initState() {
    super.initState();
    tts = TTSService("en-US");
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.roleModel.name,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.roleModel.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  widget.roleModel.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.blue),
                  onPressed: () => tts.speak(widget.roleModel.story),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.roleModel.story,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                height: 1.6,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
