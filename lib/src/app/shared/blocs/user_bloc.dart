import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/repositories/orders_repository.dart';
import 'package:gerenciamento_loja/src/app/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();
  Map<String, Map<String, dynamic>> _users = {};
  var _userRepository = AppModule.to.getDependency<UserRepository>();
  var _ordersRepository = AppModule.to.getDependency<OrderRepository>();

  Stream<List> get outUsers => _usersController.stream;

  UserBloc() {
    _addUsersListener();
  }
  _addUsersListener() {
    _userRepository.addListener((QuerySnapshot snapshot) {
      snapshot.documentChanges.forEach((change) {
        var uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribleToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribleToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  _subscribleToOrders(String uid) {
    _users[uid]['subscription'] =
        _userRepository.subscribleToOrders(uid, (QuerySnapshot orders) async {
      var numOrders = orders.documents.length;

      var money = 0.0;

      for (DocumentSnapshot d in orders.documents) {
        var order = await _ordersRepository.get(documentId: d.documentID);

        if (order.data == null) continue;

        money += order.data['totalPrice'];
      }

      _users[uid].addAll({'money': money, 'orders': numOrders});

      _usersController.add(_users.values.toList());
    });
  }

  _unsubscribleToOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  Map<String, dynamic> getUser(String uid) {
    return _users[uid];
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());
    filteredUsers.retainWhere((user) =>
        user["name"].toUpperCase().contains(search.toUpperCase()) ||
        user["email"].toUpperCase().contains(search.toUpperCase()));
    return filteredUsers;
  }
}
