import 'package:flutter/material.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/faq_help_item.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/section_help_titile.dart';

import 'contact_us_card.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support" , style: TextStyle(color: isDarkMode ? Colors.white : Colors.black  , fontWeight: FontWeight.bold) ,),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionHelpTitle(title:"Frequently Asked Questions"),
            const SizedBox(height: 16),
            const FaqHelpItem(
              question: "How do I use the Sign Language Learning feature?",
              answer:
                  "Navigate to the 'Learn Sign Language' section from the main menu. You'll find interactive lessons and quizzes to help you learn.",
            ),
            const FaqHelpItem(
              question: "How does the accessible messaging work?",
              answer:
                  "The messaging feature is designed with accessibility in mind, offering options like larger text, voice-to-text, and screen reader compatibility. You can find it under 'Messages'.",
            ),
            const FaqHelpItem(
              question: "How can I find role models in the app?",
              answer:
                  "The 'Role Models' section showcases inspiring individuals from the disability community. You can read their stories and connect with them if they have chosen to share contact information.",
            ),
            const FaqHelpItem(
              question: "How do I find disability-friendly places?",
              answer:
                  "Use the 'Accessible Places' feature. You can search for locations and filter by accessibility features. Users can also contribute by adding and rating places.",
            ),
            const SizedBox(height: 24),
            const SectionHelpTitle(title: "Contact Support"),
            const SizedBox(height: 16),
            ContactUsCard(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+20 120 138 2622",
              uri: Uri(scheme: 'tel', path: '+201201382622'),
              errorMessage: 'Could not launch phone dialer',
            ),
            const SizedBox(height: 12),
            ContactUsCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "ibraam.software@gmail.com",
              uri: Uri(scheme: 'mailto', path: 'ibraam.software@gmail.com'),
              errorMessage: 'Could not launch email app',
            ),
            const SizedBox(height: 12),
            ContactUsCard(
              icon: Icons.facebook,
              title: "Facebook",
              subtitle: "Visit our Facebook page",
              uri: Uri(
                    scheme: 'https',
                    host: 'www.facebook.com',
                    path: 'https://www.facebook.com/ibraam.magdy.848247', // Replace with your actual page
                  ),
              errorMessage: 'Could not launch Facebook',
            ),
            const SizedBox(height: 24),
            Text(
              "\nIf you can't find the answer you're looking for, please don't hesitate to reach out to our support team. We're here to help!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

}
