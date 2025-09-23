import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Listen to the 'notifications' collection in Firestore
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true) // newest first
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No notifications yet',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return Card(
              color: const Color(0xFF1E1E2C),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  data['title'] ?? 'No Title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  data['body'] ?? 'No message body',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: (){
                    // Delete the notification from Firestore
                    FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(docs[index].id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("❌ Notification deleted",
                            style: TextStyle(color: Colors.white)),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        elevation: 6,
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                      )
                    );
                  },
                ),
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.blueAccent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
