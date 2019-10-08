import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/product_repository.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  String categoryId;
  DocumentSnapshot product;
  var _productRepository = AppModule.to.getDependency<ProductRepository>();

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  Map<String, dynamic> unsavedData;

  initial() {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);

      _createdController.add(true);
    } else {
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': [],
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  saveTitle(String value) {
    unsavedData['title'] = value;
  }

  saveDescription(String value) {
    unsavedData['description'] = value;
  }

  savePrice(String value) {
    unsavedData['price'] = double.parse(value);
  }

  saveImages(List images) {
    unsavedData['images'] = images;
  }

  saveSizes(List sizes) {
    unsavedData['sizes'] = sizes;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        product.reference.updateData(unsavedData);
      } else {
        var dr = await _productRepository.add(
            categoryId, Map.from(unsavedData)..remove('images'));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      return true;
    } catch (e) {
      return false;
    } finally {
      _loadingController.add(false);
    }
  }

  Future _uploadImages(String productsId) async {
    var images = [];
    for (var item in unsavedData['images']) {
      if (item is String) {
        images.add(item);
        continue;
      }
      var url =
          await _productRepository.uploadImage(categoryId, productsId, item);

      images.add(url);
    }
    unsavedData['images'] = images;
  }

  deleteProduct(DocumentSnapshot p) {
    p.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    super.dispose();
  }
}
