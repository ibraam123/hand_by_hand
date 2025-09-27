import 'package:flutter/material.dart';
import '../../../data/models/role_model.dart';

class RoleModelDetailsScreen extends StatelessWidget {
  final RoleModel roleModel;

  const RoleModelDetailsScreen({super.key, required this.roleModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text(roleModel.name , style: TextStyle(color: isDarkMode ? Colors.white : Colors.black , fontWeight: FontWeight.bold)) , centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                roleModel.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              roleModel.name,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              roleModel.story,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                height: 1.6, // more spacing between lines
                letterSpacing: 0.3, // smoother reading
              ),
              textAlign: TextAlign.justify, // align text nicely
            ),
          ],
        ),
      ),
    );
  }
}
