import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository extends Disposable {
  var _firestore = Firestore.instance;
  final String _colletion = 'orders';

  Future<DocumentSnapshot> get({String documentId}) async {
    return await _firestore.collection(_colletion).document(documentId).get();
  }

  addListener(Function f) {
    _firestore.collection(_colletion).snapshots().listen(f);
  }

  void updateData(DocumentSnapshot order, String field, dynamic value) {
    order.reference.updateData({field: value});
  }

  void delete(DocumentSnapshot order){
    order.reference.delete();
  }
  

  @override
  void dispose() {}
}
