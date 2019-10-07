import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/orders_tab/components/order_header/order_header_widget.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/order_bloc.dart';

class OrderTileWidget extends StatelessWidget {
  final DocumentSnapshot order;
  final _orderBloc = AppModule.to.getBloc<OrderBloc>();

  final states = [
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  OrderTileWidget(this.order);

  @override
  Widget build(BuildContext context) {
    var status = order.data['status'] - 1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: status != 3,
          title: Text(
            '${order.documentID.substring(order.documentID.length - 7, order.documentID.length)}  - ${states[status]}',
            style:
                TextStyle(color: status != 3 ? Colors.grey[850] : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeaderWidget(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data['products']
                        .map<Widget>((p) => ListTile(
                              title: Text(
                                  '${p['product']['title']} - ${p['size']}'),
                              subtitle: Text('${p['category']}/${p['pid']}'),
                              trailing: Text(
                                p['quantity'].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          _orderBloc.delete(order);
                        },
                        textColor: Colors.red,
                        child: Text('Excluir'),
                      ),
                      FlatButton(
                        onPressed: status > 0
                            ? () {
                                _orderBloc.updateData(
                                    order, 'status', order.data['status'] - 1);
                              }
                            : null,
                        textColor: Colors.green[850],
                        child: Text('Regredir'),
                      ),
                      FlatButton(
                        onPressed: status < 3
                            ? () {
                                _orderBloc.updateData(
                                    order, 'status', order.data['status'] + 1);
                              }
                            : null,
                        textColor: Colors.green,
                        child: Text('Avançar'),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
