import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends Disposable {
  var _firestore = Firestore.instance;
  final String _colletion = 'users';

  subscribleToOrders(String uid, Function f) {
    _firestore
        .collection(_colletion)
        .document(uid)
        .collection('orders')
        .snapshots()
        .listen(f);
  }

  addListener(Function f) {
    _firestore.collection(_colletion).snapshots().listen(f);
  }

  @override
  void dispose() {}
}
