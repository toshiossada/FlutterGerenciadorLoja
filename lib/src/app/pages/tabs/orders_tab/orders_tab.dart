import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/orders_tab/components/order_tile/order_tile_widget.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/order_bloc.dart';

class OrdersTab extends StatelessWidget {
  final _ordersBloc = AppModule.to.getBloc<OrderBloc>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _ordersBloc.outOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
              ),
            );
          else if (snapshot.data.length == 0)
            return Center(
              child: Text(
                'Nenhum pedido encontrado!',
                style: TextStyle(color: Colors.pinkAccent),
              ),
            );
          else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return OrderTileWidget(snapshot.data[index]);
              },
            );
        },
      ),
    );
  }
}
