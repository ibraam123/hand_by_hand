import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/core/errors/error.dart';
import 'package:hand_by_hand/features/sign_language/data/models/sign_lesson_model.dart';

abstract class SignLanguageRemoteDataSource {
  Future<List<SignLessonModel>> fetchSignLessons(
      { required String langCode, required int limit, DocumentSnapshot? lastDocument});
}

class SignLanguageRemoteDataSourceImpl implements SignLanguageRemoteDataSource {
  final FirebaseFirestore firestore;

  SignLanguageRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<SignLessonModel>> fetchSignLessons(
      {required String langCode, required int limit, DocumentSnapshot? lastDocument}) async {
    try {
      Query query = firestore
      .collection('sign_language')
      .limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        return []; // ✅ no error, just end of list
      }

      return snapshot.docs
          .map((doc) =>
          SignLessonModel.fromMap(doc.data() as Map<String, dynamic>, langCode, snapshot: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure('Failed to fetch sign lessons: ${e.message}');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: ${e.toString()}');
    }
  }
}