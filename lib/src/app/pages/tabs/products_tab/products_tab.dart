import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/products_tab/category_tile/category_tile_widget.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/product_bloc.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin{
  final _productBloc = AppModule.to.getBloc<ProductBloc>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return FutureBuilder(
      future: _productBloc.getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        else
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                CategoryTileWidget(snapshot.data.documents[index]),
          );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
