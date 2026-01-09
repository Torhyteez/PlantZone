import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<FirebaseService> authService = ValueNotifier(FirebaseService());

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance; 

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChange => auth.authStateChanges();

  Future<UserCredential> signIn({required String email, required String password}) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );


    if (userCredential.user != null) {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'userID': userCredential.user!.uid,
        'email': email,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}