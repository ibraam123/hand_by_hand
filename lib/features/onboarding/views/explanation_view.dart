import 'package:flutter/material.dart';
import 'package:hand_by_hand/features/onboarding/widgets/explanation_view_body.dart';
import '../models/explanation_screen_model.dart';

class ExplanationView extends StatelessWidget {
  const ExplanationView({super.key,required this.explanationScreenModel});
  final ExplanationScreenModel explanationScreenModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExplanationViewBody(explanationScreenModel: explanationScreenModel,),
    );
  }
}
