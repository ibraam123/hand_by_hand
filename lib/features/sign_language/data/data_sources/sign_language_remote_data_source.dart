import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/core/errors/error.dart';
import 'package:hand_by_hand/features/sign_language/data/models/sign_lesson_model.dart';

abstract class SignLanguageRemoteDataSource {
  Future<List<SignLessonModel>> fetchSignLessons();
}

class SignLanguageRemoteDataSourceImpl implements SignLanguageRemoteDataSource {
  final FirebaseFirestore firestore;

  SignLanguageRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<SignLessonModel>> fetchSignLessons() async {
    try {
      final snapshot = await firestore.collection('sign_language').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => SignLessonModel.fromMap(doc.data()))
            .toList();
      } else {
        throw ServerFailure('No sign lessons found.');
      }
    } on FirebaseException catch (e) {
      throw ServerFailure('Failed to fetch sign lessons: ${e.message}');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: ${e.toString()}');
    }
  }
}