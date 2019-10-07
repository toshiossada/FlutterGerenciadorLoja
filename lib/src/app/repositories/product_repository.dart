import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository extends Disposable {
  var _firestore = Firestore.instance;
  final String _colletion = 'products';

  addListener(Function f) {
    _firestore.collection(_colletion).snapshots().listen(f);
  }

  Future<QuerySnapshot> getDocuments(){
    return _firestore.collection(_colletion).getDocuments();
  }
  Future<QuerySnapshot> getItems(DocumentSnapshot category){
    return category.reference.collection('items').getDocuments();
  }

  @override
  void dispose() {}
}
