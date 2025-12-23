import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
ValueNotifier<FirebaseService> authService = ValueNotifier(FirebaseService());

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChange => auth.authStateChanges();

  Future<UserCredential> signIn ({required String email, required String password}) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp ({required String email, required String password}) async {
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut () async {
    await auth.signOut();
  } 
}