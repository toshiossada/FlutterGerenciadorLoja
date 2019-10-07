import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/product_bloc.dart';

class CategoryTileWidget extends StatelessWidget {
  final DocumentSnapshot category;
  final _productBloc = AppModule.to.getBloc<ProductBloc>();

  CategoryTileWidget(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(category.data['icon']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            category.data['title'],
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: _productBloc.getItems(category),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.documents.length == 0)
                  return Container(
                    child: Text('Sem Items'),
                  );
                else
                  return Column(
                    children: snapshot.data.documents
                        .map((doc) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: 
                                    NetworkImage(doc.data['images'] != null ? doc.data['images'][0] : 'https://bigsamsrawbar.com/wp-content/plugins/wordpress-ecommerce/marketpress-includes/images/default-product.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(doc.data['title']),
                              trailing: Text(
                                  'R\$${doc.data['price'].toStringAsFixed(2)}'),
                              onTap: () {},
                            ))
                        .toList(),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
