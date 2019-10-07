import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/orders_repository.dart';
import 'package:gerenciamento_loja/src/app/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class OrdersTabBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();
  List<DocumentSnapshot> _orders = [];

  Stream<List> get outOrders => _ordersController.stream;
  var _ordersRepository = AppModule.to.getDependency<OrderRepository>();
  var _userRepository = AppModule.to.getDependency<UserRepository>();

  OrdersTabBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _ordersRepository.addListener((QuerySnapshot snapshot) {
      snapshot.documentChanges.forEach((change) {
        var oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((o) => o.documentID == oid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.remove(oid);
            break;
        }

        _ordersController.add(_orders);
      });
    });
  }

  void updateData(DocumentSnapshot order, String field, dynamic value) {
    _ordersRepository.updateData(order, field, value);
  }

  Future<void> delete(
      DocumentSnapshot order) async {
    await _userRepository.deleteOrders(order['clientId'], order.documentID);

    _ordersRepository.delete(order);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }
}
