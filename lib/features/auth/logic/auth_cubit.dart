import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hand_by_hand/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth, this._firestore) : super(AuthInitial());
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;


  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final OAuthCredential credential =
      FacebookAuthProvider.credential(result.accessToken!.tokenString);
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
      final idToken = (await account.authentication).idToken;
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
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
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
