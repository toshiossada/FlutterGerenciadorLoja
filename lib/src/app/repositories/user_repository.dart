import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends Disposable {
  var firestore = Firestore.instance;

  subscribleToOrders(String uid, Function f){
    firestore.collection('users').document(uid).collection('orders').snapshots().listen(f);
  }

  addListener(Function f){
    firestore.collection('users').snapshots().listen(f);
  }
  
  @override
  void dispose() {}
}
