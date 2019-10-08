import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductRepository extends Disposable {
  var _firestore = Firestore.instance;
  final String _colletion = 'products';

  addListener(Function f) {
    _firestore.collection(_colletion).snapshots().listen(f);
  }

  Future<QuerySnapshot> getDocuments() {
    return _firestore.collection(_colletion).getDocuments();
  }

  Future<QuerySnapshot> getItems(DocumentSnapshot category) {
    return category.reference.collection('items').getDocuments();
  }

  Future<String> uploadImage(
      String categoryId, String productsId, File image) async {
    StorageUploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child(categoryId)
        .child(productsId)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(image);
    StorageTaskSnapshot s = await uploadTask.onComplete;

    return await s.ref.getDownloadURL();
  }

  Future<DocumentReference> add(
      String categoryId, Map<String, dynamic> product) async {
    return await _firestore
        .collection(_colletion)
        .document(categoryId)
        .collection('items')
        .add(product);
  }

  @override
  void dispose() {}
}
