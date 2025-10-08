

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';

abstract class SignLessonRepo {
  Future<List<SignLessonEntitiy>> getSignLessons({
    required String langCode,
    required int limit,
    DocumentSnapshot? lastDocument,
  });}
