import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('feedbacks').add({
            'userId': user.email,
            'feedback': _feedbackController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(General.thanksFeedback.tr()),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit feedback: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // current theme (dark / light)
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Profile.feedback.tr(),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: Profile.feedback.tr(),
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? General.enterYourFeedback.tr() : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text(General.submit.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
