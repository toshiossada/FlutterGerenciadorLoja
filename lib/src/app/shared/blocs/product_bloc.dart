import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/product_repository.dart';

class ProductBloc extends BlocBase {
  final _productRepository = AppModule.to.getDependency<ProductRepository>();

  Future<QuerySnapshot> getDocuments() {
    return _productRepository.getDocuments();
  }

  Future<QuerySnapshot> getItems(DocumentSnapshot category) {
    return _productRepository.getItems(category);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
