import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hand_by_hand/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth, this._firestore) : super(AuthInitial());
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  bool rememberMe = false;

  Future<void> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool("remember_me") ?? false;
    emit(RememberMe(isSelected: rememberMe));
  }

  Future<void> toggleRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember_me", value);
    rememberMe = value;
    emit(RememberMe(isSelected: value));
  }

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final userCred = await _auth.signInWithCredential(credential);
      final firebaseUser = userCred.user!;
      final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        final parts = (firebaseUser.displayName ?? '').trim().split(' ');
        final newUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          firstName: parts.isNotEmpty ? parts.first : '',
          lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
          birthDate: DateTime.now(), // you may want to ask user later
          gender: 'unspecified', // same here
        );
        await userDoc.set(newUser.toMap());
        emit(AuthSuccess(user: newUser));
      } else {
        final data = snapshot.data()!;
        final existingUser = UserModel.fromMap(data);
        emit(AuthSuccess(user: existingUser));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      UserCredential userCred;

      // Mobile/Desktop: google_sign_in v7
      final signIn = GoogleSignIn.instance;
      await signIn.initialize(
        clientId:
            "1015696421423-th7o6o7iekmqanad9c9oood4jktnsp82.apps.googleusercontent.com",
      ); // for iOS: pass clientId

      final account = await signIn.authenticate();
      final idToken = (account.authentication).idToken;
      if (idToken == null) throw Exception('Google idToken was null');

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      userCred = await _auth.signInWithCredential(credential);

      final firebaseUser = userCred.user!;
      final userDoc = _firestore.collection('users').doc(firebaseUser.uid);

      // If first login, create Firestore doc
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        final parts = (firebaseUser.displayName ?? '').trim().split(' ');
        final newUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          firstName: parts.isNotEmpty ? parts.first : '',
          lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
          birthDate: DateTime.now(), // you may want to ask user later
          gender: 'unspecified', // same here
        );
        await userDoc.set(newUser.toMap());
        emit(AuthSuccess(user: newUser));
      } else {
        // Load existing user from Firestore
        final data = snapshot.data()!;
        final existingUser = UserModel.fromMap(data);
        emit(AuthSuccess(user: existingUser));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    if (email.isEmpty) {
      emit(ForgotPasswordError('Please enter your email address'));
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage =
              'No account found with this email address. Please check your email or sign up.';
          break;
        case 'user-disabled':
          errorMessage =
              'This user account has been disabled. Please contact support.';
          break;
        case 'missing-android-pkg-name':
          errorMessage = 'Android package name is required for this operation.';
          break;
        case 'missing-continue-uri':
          errorMessage = 'Continue URL is required for this operation.';
          break;
        case 'missing-ios-bundle-id':
          errorMessage = 'iOS bundle ID is required for this operation.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Password reset is not enabled. Please contact support.';
          break;
        default:
          errorMessage =
              'An error occurred while sending reset email. Please try again.';
      }

      emit(ForgotPasswordError(errorMessage));
    } catch (e) {
      emit(
        ForgotPasswordError('An unexpected error occurred. Please try again.'),
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
  }) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        gender: gender,
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());

      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
