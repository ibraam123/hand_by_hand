import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String message;
  Failure(this.message);
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

  factory ServerFailure.fromAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return ServerFailure(error.message ?? 'An unknown authentication error occurred.');
    } else if (error is Exception) {
      String errorString = error.toString();
      if (errorString.contains('Exception: ')) {
        return ServerFailure(errorString.split('Exception: ')[1]);
      }

      return ServerFailure(errorString);
    } else {
      return ServerFailure('Authentication failed. Please try again.');
    }
  }
}
