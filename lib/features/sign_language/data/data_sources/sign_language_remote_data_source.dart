// lib/features/role_models/data/datasources/role_model_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/features/sign_language/data/models/sign_lesson_model.dart';

abstract class SignLanguageRemoteDataSource {
  Future<List<SignLessonModel>> fetchSignLessons();
}

class SignLanguageRemoteDataSourceImpl implements SignLanguageRemoteDataSource {
  final FirebaseFirestore firestore;

  SignLanguageRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<SignLessonModel>> fetchSignLessons() async {
    final snapshot = await firestore.collection('sign_language').get();
    return snapshot.docs
        .map((doc) => SignLessonModel.fromMap(doc.data()))
        .toList();
  }

}
