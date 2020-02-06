import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  FirebaseAuth _auth;
  Firestore _firestore;

  MyFirebase();

  void initAuth() {
    _auth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> registerUser(
      {String emailStr, @required String password}) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: emailStr, password: password))
        .user;
    return user;
  }

  Future<FirebaseUser> signIn(
      {@required String email, @required String password}) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  void initStore() {
    _firestore = Firestore.instance;
  }

  Future<Stream<QuerySnapshot>> getAllMessages() async {
    return Firestore.instance
        .collection('discussion_iphone_v_android')
        .orderBy('datetime')
        .snapshots();
  }
}
