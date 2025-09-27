import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/message_entitiy.dart';

abstract class CommunityChatRepository {
  Stream<List<MessageEntity>> getMessages();
  Future<void> sendMessage(String text);
}

class CommunityChatRepositoryImpl implements CommunityChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CommunityChatRepositoryImpl(this.firestore, this.auth);

  @override
  Stream<List<MessageEntity>> getMessages() {
    return firestore
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MessageEntity(
          id: data["id"] ?? "",
          name: data["name"] ??
              (data["id"] as String).split('@').first,
          text: data["text"] ?? "",
          createdAt: (data["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String text) async {
    final user = auth.currentUser;
    if (user == null || text.trim().isEmpty) return;

    final senderName = user.displayName ?? user.email!.split('@').first;

    await firestore.collection("messages").add({
      "text": text.trim(),
      "id": user.email,
      "senderName": senderName,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
