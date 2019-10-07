import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/orders_tab/components/order_header/order_header_widget.dart';

class OrderTileWidget extends StatelessWidget {
  final DocumentSnapshot order;

  final states = [
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  OrderTileWidget(this.order);

  @override
  Widget build(BuildContext context) {
    var status  = order.data['status'] - 1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            '${order.documentID.substring(order.documentID.length - 7, order.documentID.length)}  - ${states[status]}',
            style: TextStyle(
                color: order.data['status'] != 4
                    ? Colors.grey[850]
                    : Colors.green),
          ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      OrderHeaderWidget(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: order.data['products'].map<Widget>(
                          (p) => ListTile(
                            title: Text('${p['product']['title']} - ${p['size']}'),
                            subtitle: Text('${p['category']}/${p['pid']}'),
                            trailing: Text(
                              p['quantity'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            contentPadding: EdgeInsets.zero,
                          )
                        ).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {},
                            textColor: Colors.red,
                            child: Text('Excluir'),
                          ),
                          FlatButton(
                            onPressed: () {},
                            textColor: Colors.green[850],
                            child: Text('Avançar'),
                          ),
                          FlatButton(
                            onPressed: () {},
                            textColor: Colors.green,
                            child: Text('Regredir'),
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
