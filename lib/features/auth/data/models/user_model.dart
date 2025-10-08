import 'package:hand_by_hand/features/auth/data/models/user_progress.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserProgress? progress;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.progress,
  }) {
    // ADD: Input validation
    if (id.isEmpty) throw ArgumentError("User ID cannot be empty");
    if (email.isEmpty) throw ArgumentError("Email cannot be empty");
    if (!email.contains('@')) throw ArgumentError("Invalid email format");
    if (firstName.isEmpty) throw ArgumentError("First name cannot be empty");
    if (lastName.isEmpty) throw ArgumentError("Last name cannot be empty");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'progress': progress?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
          progress: map['progress'] != null
              ? UserProgress.fromMap(map['progress'])
              : null
      );
    } catch (e) {
      throw FormatException("Invalid user data: $e");
    }
  }

  // ADD: Helper method for display name
  String get fullName => '$firstName $lastName';

  // ADD: Copy with method for updates
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserProgress? progress,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      progress: progress ?? this.progress,
    );
  }
  List<Object?> get props => [id, email, firstName, lastName];

}