import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app_flutter/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();

    return UserModel.fromJson({'id': uid, ...doc.data()!});
  }

  Future<UserModel?> register(
    String email,
    String password,
    String name,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserModel(id: uid, email: email, name: name);
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) return null;

    return UserModel.fromJson({'id': firebaseUser.uid, ...doc.data()!});
  }
}
