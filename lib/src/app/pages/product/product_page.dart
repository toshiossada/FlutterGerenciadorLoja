import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/components/imagesWidget/images_widget.dart';
import 'package:gerenciamento_loja/src/app/components/product_size/product_size_widget.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) =>
              Text(snapshot.data ? 'Editar Produto' : "Criar Produto"),
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) => snapshot.data
                ? StreamBuilder(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : removeProduct,
                      );
                    },
                  )
                : Container(),
          ),
          StreamBuilder(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Tamanhos",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    ProductSizeWidget(
                      initialValue: snapshot.data['sizes'],
                      onSaved: (e) {},
                      validator: (e) {},
                    ),
                  ],
                );
              },
            ),
          ),
          StreamBuilder(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  removeProduct() async {
    _productBloc.deleteProduct(product);
    Navigator.pop(context);
  }

  saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Salvando produto...',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        duration: Duration(minutes: 1),
      ));

      var success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? 'Produto salvo' : 'Erro ao salvar produto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }
}
