import 'package:flutter/material.dart';
import '../../../data/models/role_model.dart';

class RoleModelDetailsScreen extends StatelessWidget {
  final RoleModel roleModel;

  const RoleModelDetailsScreen({super.key, required this.roleModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roleModel.name , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold)) , centerTitle: true),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              roleModel.story,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
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
