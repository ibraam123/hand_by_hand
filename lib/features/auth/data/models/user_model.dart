class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
  }) {
    // ADD: Input validation
    if (id.isEmpty) throw ArgumentError("User ID cannot be empty");
    if (email.isEmpty) throw ArgumentError("Email cannot be empty");
    if (!email.contains('@')) throw ArgumentError("Invalid email format");
    if (firstName.isEmpty) throw ArgumentError("First name cannot be empty");
    if (lastName.isEmpty) throw ArgumentError("Last name cannot be empty");
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError("Birth date cannot be in the future");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        birthDate: DateTime.parse(map['birthDate'] as String),
        gender: map['gender'] as String,
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
    DateTime? birthDate,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }
}