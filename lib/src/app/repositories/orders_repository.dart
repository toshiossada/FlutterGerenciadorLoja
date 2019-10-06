import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository extends Disposable {
  var _firestore = Firestore.instance;

  Future<DocumentSnapshot> get(String documentId) async{
    return await _firestore.collection('orders').document(documentId).get();
  }

  @override
  void dispose() {}
}
