import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final _formKey;
  late final _feedbackController;
  late final FirebaseFirestore _firestore ;
  late final FirebaseAuth _auth;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
    _feedbackController = TextEditingController();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('feedbacks').add({
            'userId': user.email,
            'feedback': _feedbackController.text.trim(),
            'timestamp': FieldValue.serverTimestamp(),
          });
          CustomSnackBar.show(
            context,
            message: General.thanksFeedback.tr(),
            backgroundColor: Colors.green,
            textColor: Colors.white,
            icon: Icons.check_circle,
            duration: const Duration(seconds: 3),
          );
        } catch (e) {
          if (mounted) {
            CustomSnackBar.show(
              context,
              message: e.toString(),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              icon: Icons.error,
              duration: const Duration(seconds: 3),
            );
          }
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
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  validator: (value) => value == null || value.trim().isEmpty
                      ? General.enterYourFeedback.tr()
                      : null,
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
      ),
    );
  }
}
