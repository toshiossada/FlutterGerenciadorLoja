import 'package:gerenciamento_loja/src/app/shared/blocs/user_bloc.dart';
import 'package:gerenciamento_loja/src/app/repositories/orders_repository.dart';
import 'package:gerenciamento_loja/src/app/repositories/user_repository.dart';
import 'package:gerenciamento_loja/src/app/shared/components/user_tile/user_tile_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/users_tab/users_tab_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/Home/home_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/login/components/input_field/input_field_bloc.dart';
import 'package:gerenciamento_loja/src/app/pages/login/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_bloc.dart';
import 'package:gerenciamento_loja/src/app/app_widget.dart';
import 'package:gerenciamento_loja/src/app/repositories/login_repository.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => UserBloc()),
        Bloc((i) => UserTileBloc()),
        Bloc((i) => UsersTabBloc()),
        Bloc((i) => HomeBloc()),
        Bloc((i) => InputFieldBloc()),
        Bloc((i) => LoginBloc()),
        Bloc((i) => AppBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => OrderRepository()),
        Dependency((i) => UserRepository()),
        Dependency((i) => LoginRepository()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
