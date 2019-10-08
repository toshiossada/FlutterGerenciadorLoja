import 'package:gerenciamento_loja/src/app/components/imagesWidget/image_source_sheet/image_source_sheet_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/imagesWidget/images_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/input_field/input_field_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/orders_tab/order_tile/order_header/order_header_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/orders_tab/order_tile/order_tile_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/orders_tab/orders_tab_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/products_tab/category_tile/category_tile_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/products_tab/products_tab_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/users_tab/user_tile/user_tile_bloc.dart';
import 'package:gerenciamento_loja/src/app/components/tabs/users_tab/users_tab_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/product/product_bloc.dart';
import 'package:gerenciamento_loja/src/app/repositories/product_repository.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/order_bloc.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/user_bloc.dart';
import 'package:gerenciamento_loja/src/app/repositories/orders_repository.dart';
import 'package:gerenciamento_loja/src/app/repositories/user_repository.dart';
import 'package:gerenciamento_loja/src/app/pages/Home/home_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/login/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_bloc.dart';
import 'package:gerenciamento_loja/src/app/app_widget.dart';
import 'package:gerenciamento_loja/src/app/repositories/login_repository.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ImageSourceSheetBloc()),
        Bloc((i) => ImagesBloc()),
        Bloc((i) => ProductBloc()),
        Bloc((i) => CategoryTileBloc()),
        Bloc((i) => ProductBloc()),
        Bloc((i) => ProductsTabBloc()),
        Bloc((i) => OrderBloc()),
        Bloc((i) => UserBloc()),
        Bloc((i) => OrderHeaderBloc()),
        Bloc((i) => OrderTileBloc()),
        Bloc((i) => OrdersTabBloc()),
        Bloc((i) => UserTileBloc()),
        Bloc((i) => UsersTabBloc()),
        Bloc((i) => HomeBloc()),
        Bloc((i) => InputFieldBloc()),
        Bloc((i) => LoginBloc()),
        Bloc((i) => AppBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => ProductRepository()),
        Dependency((i) => OrderRepository()),
        Dependency((i) => UserRepository()),
        Dependency((i) => LoginRepository()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
