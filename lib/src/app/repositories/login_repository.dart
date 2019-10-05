import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginRepository extends Disposable {
  FirebaseAuth instance = FirebaseAuth.instance;
  Firestore get firestore => Firestore.instance;

  Future<AuthResult> login(
      {@required String email, @required String pass}) async {
    
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: pass);
    return result;
  }

  Future<DocumentSnapshot> verifyPrivileges(FirebaseUser user) async {
    var result = await firestore.collection('admins').document(user.uid).get();
    return result;
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
