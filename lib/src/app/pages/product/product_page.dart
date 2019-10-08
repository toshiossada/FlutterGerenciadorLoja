import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/components/imagesWidget/images_widget.dart';
import 'package:gerenciamento_loja/src/app/validators/product_validator.dart';

import 'product_bloc.dart';

class ProductPage extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;
  ProductPage({@required this.categoryId, this.product});

  @override
  _ProductPageState createState() => _ProductPageState(categoryId, product);
}

class _ProductPageState extends State<ProductPage> with ProductValidator {
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
            onPressed: saveProduct,
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
                Text(
                  "Imagens",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                ImagesWidget(
                  context: context,
                  initialValue: snapshot.data["images"],
                  onSaved: _productBloc.saveImages,
                  validator: validateImages,
                ),
                TextFormField(
                  initialValue: snapshot.data['title'],
                  style: _fieldStyle,
                  decoration: _buildDecoration('Titulo'),
                  onSaved: _productBloc.saveTitle,
                  validator: validateTitle,
                ),
                TextFormField(
                  style: _fieldStyle,
                  initialValue: snapshot.data['description'],
                  decoration: _buildDecoration('Descrição'),
                  maxLines: 6,
                  onSaved: _productBloc.saveDescription,
                  validator: validateDescription,
                ),
                TextFormField(
                  style: _fieldStyle,
                  initialValue: snapshot.data['price']?.toStringAsFixed(2),
                  decoration: _buildDecoration('Preço'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: _productBloc.savePrice,
                  validator: validatePrice,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  saveProduct() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }
}
