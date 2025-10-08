import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/user_model.dart';
import '../../data/models/user_progress.dart';
import '../../data/repo/user_repo.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;

  const UserRepositoryImpl(this.firestore);

  @override
  Future<UserModel> getUser(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    return UserModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateProgress(String userId, UserProgress progress) async {
    await firestore.collection('users').doc(userId).update({
      'progress': progress.toMap(),
    });
  }
}
