import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/product/product_bloc.dart';

class ProductPage extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;
  ProductPage({@required this.categoryId, this.product});

  @override
  _ProductPageState createState() => _ProductPageState(categoryId, product);
}

class _ProductPageState extends State<ProductPage> {
  final String categoryId;
  final DocumentSnapshot product;
  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();

  _ProductPageState(this.categoryId, this.product)
      : _productBloc = AppModule.to.getBloc<ProductBloc>()
          ..categoryId = categoryId
          ..product = product
          ..initial();

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text("Criar Produto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  initialValue: snapshot.data['title'],
                  style: _fieldStyle,
                  decoration: _buildDecoration('Titulo'),
                  onSaved: (t) {},
                  validator: (t) {},
                ),
                TextFormField(
                  style: _fieldStyle,
                  initialValue: snapshot.data['description'],
                  decoration: _buildDecoration('Descrição'),
                  maxLines: 6,
                  onSaved: (t) {},
                  validator: (t) {},
                ),
                TextFormField(
                  style: _fieldStyle,
                  initialValue: snapshot.data['price']?.toStringAsFixed(2),
                  decoration: _buildDecoration('Preço'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (t) {},
                  validator: (t) {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
