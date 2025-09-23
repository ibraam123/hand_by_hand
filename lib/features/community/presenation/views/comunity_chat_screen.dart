import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hand_by_hand/features/community/presenation/widgets/custom_text_field.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // safely get the logged-in user email
    currentUserId = _auth.currentUser?.email ?? "unknown";
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    await _firestore.collection("messages").add({
      "text": _controller.text.trim(),
      "id": currentUserId,
      "createdAt": FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Community Chat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              /// --- Real-time Chat Messages
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("messages")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true, // newest at bottom
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final isMe = data["id"] == currentUserId;

                        return Align(
                          alignment:
                              isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.75, // Max width of message bubble
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.deepPurpleAccent
                                  : Colors.blue,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              data["text"] ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: constraints.maxWidth < 600 ? 14 : 16, // Responsive font size
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              /// --- Input Field
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.02), // Responsive padding
                  child: CustomTextField(
                      controller: _controller, onSend: _sendMessage),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
