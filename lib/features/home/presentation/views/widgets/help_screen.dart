import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text("Q: How can I reset my password?"),
            Text("A: Go to Profile > Change Password."),
            SizedBox(height: 16),
            Text("Q: How do I contact support?"),
            Text("A: You can email us at support@example.com."),
            SizedBox(height: 16),
            Text(
              "Need more help?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Send us an email at: support@example.com"),
          ],
        ),
      ),
    );
  }
}
