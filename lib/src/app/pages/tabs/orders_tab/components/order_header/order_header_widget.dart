import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/users_tab/users_tab_bloc.dart';

class OrderHeaderWidget extends StatelessWidget {
  final DocumentSnapshot order;
  final _userBloc = AppModule.to.getBloc<UsersTabBloc>();

  OrderHeaderWidget(this.order);

  @override
  Widget build(BuildContext context) {
    var user = _userBloc.getUser(order.data['clientId']);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user['name']),
              Text(user['address']),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Produtos: R\$${order.data['produtcsPrice'].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Total R\$${order.data['totalPrice'].toStringAsFixed(2)} ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
