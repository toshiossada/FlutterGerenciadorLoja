import 'package:flutter/material.dart';

class OrderHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Toshi'),
              Text('Rua Filipinas, 428'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Preço Produtos',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Preço total',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
