import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support" , style: TextStyle(color: Colors.white  , fontWeight: FontWeight.bold) ,),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle(context, "Frequently Asked Questions"),
            const SizedBox(height: 16),
            _buildFAQItem(
              context,
              question: "How do I use the Sign Language Learning feature?",
              answer:
                  "Navigate to the 'Learn Sign Language' section from the main menu. You'll find interactive lessons and quizzes to help you learn.",
            ),
            _buildFAQItem(
              context,
              question: "How does the accessible messaging work?",
              answer:
                  "The messaging feature is designed with accessibility in mind, offering options like larger text, voice-to-text, and screen reader compatibility. You can find it under 'Messages'.",
            ),
            _buildFAQItem(
              context,
              question: "How can I find role models in the app?",
              answer:
                  "The 'Role Models' section showcases inspiring individuals from the disability community. You can read their stories and connect with them if they have chosen to share contact information.",
            ),
            _buildFAQItem(
              context,
              question: "How do I find disability-friendly places?",
              answer:
                  "Use the 'Accessible Places' feature. You can search for locations and filter by accessibility features. Users can also contribute by adding and rating places.",
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Contact Support"),
            const SizedBox(height: 16),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.phone_outlined, color: theme.colorScheme.primary),
                title: const Text(
                  "Call Us (Coming Soon)",
                  style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.white),
                ),
                subtitle: const Text("Phone support will be available shortly." , style: TextStyle(color: Colors.white)),
                enabled: false,
                onTap: () {},
              ),
            ),
            Text(
              "\nIf you can't find the answer you're looking for, please don't hesitate to reach out to our support team. We're here to help!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildFAQItem(BuildContext context, {required String question, required String answer}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.colorScheme.secondary,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          question,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
