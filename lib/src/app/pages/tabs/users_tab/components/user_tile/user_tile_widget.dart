import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTileWidget extends StatelessWidget {
  final Map<String, dynamic> user;

  UserTileWidget(this.user);

  var style = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    if (user.containsKey('money'))
      return ListTile(
        title: Text(
          user['name'],
          style: style,
        ),
        subtitle: Text(
          user['email'],
          style: style,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Pedidos: ${user['orders']}',
              style: style,
            ),
            Text(
              'Gasto: R\$${user['money'].toStringAsFixed(2)}',
              style: style,
            )
          ],
        ),
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
              width: 200,
              child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(200),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20,
              width: 50,
              child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(200),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
              ),
            ),
          ],
        ),
      );
  }
}
