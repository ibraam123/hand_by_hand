import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String message;
  Failure(this.message);
}

class FailureHandler {
  static String mapException(dynamic error) {
    final failure = ServerFailure.fromAuthError(error);
    return failure.message;
  }
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } else if (statusCode == 500) {
      return ServerFailure('Internal server error, Please try later!');
    }
    return ServerFailure('Oops, there was an error. Please try again.');
  }

  factory ServerFailure.fromFirestoreError(dynamic error) {
    if (error is FirebaseException && error.code == 'permission-denied') {
      return ServerFailure('You do not have permission to access this data.');
    } else if (error is FirebaseException && error.code == 'unavailable') {
      return ServerFailure('Firestore service temporarily unavailable.');
    } else {
      return ServerFailure('An unexpected Firestore error occurred.');
    }
  }


  factory ServerFailure.fromAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return ServerFailure('The email address is badly formatted.');
        case 'user-disabled':
          return ServerFailure('This account has been disabled. Contact support.');
        case 'user-not-found':
          return ServerFailure('No account found for this email.');
        case 'wrong-password':
          return ServerFailure('Incorrect password. Please try again.');
        case 'email-already-in-use':
          return ServerFailure('This email is already registered.');
        case 'weak-password':
          return ServerFailure('Your password is too weak. Try a stronger one.');
        default:
          return ServerFailure(error.message ?? 'Authentication failed.');
      }
    } else if (error is FirebaseException) {
      return ServerFailure(error.message ?? 'Authentication failed.');
    } else if (error is Exception) {
      return ServerFailure(error.toString().replaceFirst('Exception: ', ''));
    } else {
      return ServerFailure('Something went wrong. Please try again.');
    }
  }

}
