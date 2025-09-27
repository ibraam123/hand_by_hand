import 'package:flutter/material.dart';
import 'package:hand_by_hand/features/know_about_us/presenatation/widgets/about_us_card.dart';

import '../../models/know_about_us_model.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final sections = [
      AboutUsSection(
        icon: Icons.flag_rounded,
        title: "Our Mission",
        content:
        "To empower individuals within the disability community by offering a comprehensive suite of accessible tools, invaluable resources, and enriching educational content. We strive to foster independence, enhance communication, and promote inclusivity.",
      ),
      AboutUsSection(
        icon: Icons.history_edu_rounded,
        title: "Our Story",
        content:
        "Hand by Hand was born from a desire to address the everyday challenges faced by people with disabilities. We identified critical gaps in communication and accessibility and embarked on a journey to create solutions that genuinely make life easier and more fulfilling.",
      ),
      AboutUsSection(
        icon: Icons.lightbulb_outline_rounded,
        title: "Features & Impact",
        content:
        "• Intuitive Sign Language Learning: Master sign language through interactive lessons and practical exercises.\n"
            "• Accessible Places Locator: Discover nearby locations with disability-friendly amenities.\n"
            "• Inspiring Role Models: Connect with and learn from individuals who have overcome challenges and achieved success.\n"
            "• Supportive Community Forum: Engage with peers, share experiences, and find encouragement in a safe and welcoming space.",
      ),
      AboutUsSection(
        icon: Icons.handshake_rounded,
        title: "Join Us",
        content:
        "Become a part of the Hand by Hand community! Whether you're looking for resources, want to learn sign language, or wish to connect with others, we welcome you. Together, we can make a difference.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Know More About Us",
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return AboutUsSectionCard(
            section: section,
          );
        },
      ),
    );
  }

}
