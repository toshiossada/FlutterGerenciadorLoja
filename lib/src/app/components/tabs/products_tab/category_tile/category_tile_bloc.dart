import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/product_repository.dart';

class CategoryTileBloc extends BlocBase {
  final _productRepository = AppModule.to.getDependency<ProductRepository>();

  Future<QuerySnapshot> getItems(DocumentSnapshot category) {
    return _productRepository.getItems(category);
  }

  deleteProduct(DocumentSnapshot p) {
    p.reference.delete();
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
  }
}
