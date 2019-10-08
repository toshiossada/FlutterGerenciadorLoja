import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/product_repository.dart';

class ProductsTabBloc extends BlocBase {
  final _productRepository = AppModule.to.getDependency<ProductRepository>();

  Stream<QuerySnapshot> getDocuments() {
    return _productRepository.getDocuments();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
