import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        border: Border(
            top: BorderSide(
                color: isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: Community.typeMessage.tr(),
                hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                filled: true,
                fillColor:
                    isDarkMode ? Colors.grey[800] : Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: CircleAvatar(
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.send,
                  color: isDarkMode ? Colors.black : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
