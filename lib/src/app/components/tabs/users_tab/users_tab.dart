import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/shared/blocs/user_bloc.dart';

import 'user_tile/user_tile_widget.dart';

class UsersTab extends StatelessWidget {
  var _userBloc = AppModule.to.getBloc<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (value){
              _userBloc.onChangedSearch(value);
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
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
                      'Nenhum usuário encontrado',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  );
                else
                  return ListView.separated(
                    itemBuilder: (context, index) => UserTileWidget(snapshot.data[index]),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length,
                  );
              }),
        )
      ],
    );
  }
}
