import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/errors/error.dart';
import 'package:hand_by_hand/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._auth,
    this._firestore,
    this._googleSignIn,
  ) : super(AuthInitial());

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  bool rememberMe = false;


  Future<void> loadRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool("remember_me") ?? false;
    emit(RememberMe(isSelected: rememberMe));
  }



  Future<void> toggleRememberMe(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember_me", value);
    rememberMe = value;
    emit(RememberMe(isSelected: value));
  }


  Future<void> signInWithGoogle() async {
    emit(AuthLoading(
      action: AuthAction.google
    ));
    try {
      UserCredential userCred;

      // Mobile/Desktop: google_sign_in v7
      await _googleSignIn.initialize(
        clientId:
            "1015696421423-th7o6o7iekmqanad9c9oood4jktnsp82.apps.googleusercontent.com",
      ); // for iOS: pass clientId

      final account = await _googleSignIn.authenticate();
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
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', newUser.firstName);
        await prefs.setString('lastName', newUser.lastName);
        await prefs.setString('email', newUser.email);
        emit(AuthSuccess(user: newUser));
      } else {
        // Load existing user from Firestore
        final data = snapshot.data()!;
        final existingUser = UserModel.fromMap(data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', existingUser.firstName);
        await prefs.setString('lastName', existingUser.lastName);
        await prefs.setString('email', existingUser.email);
        emit(AuthSuccess(user: existingUser));
      }
    } catch (e) {
      emit(AuthError(
        FailureHandler.mapException(e)
      ));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    if (email.isEmpty) {
      emit(const ForgotPasswordError('Please enter your email address'));
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError((
      FailureHandler.mapException(e)
      )));
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading(
      action: AuthAction.email
    ));
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;

      final doc = await _firestore.collection('users').doc(uid).get();
      final user = UserModel.fromMap(doc.data()!);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', user.firstName);
      await prefs.setString('lastName', user.lastName);
      await prefs.setString('email', user.email);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(
      FailureHandler.mapException(e)
      ));
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
    emit(AuthLoading(
      action: AuthAction.signup
    ));
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', user.firstName);
      await prefs.setString('lastName', user.lastName);
      await prefs.setString('email', user.email);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(
      FailureHandler.mapException(e)
      ));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading(
      action: AuthAction.logout
    ));
    try {
      await _auth.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('firstName');
      await prefs.remove('lastName');
      await prefs.remove('email');
      emit(AuthLogout());
    } catch (e) {
      emit(AuthError(
      FailureHandler.mapException(e)
      ));
    }
  }
}
