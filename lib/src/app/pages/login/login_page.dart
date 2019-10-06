import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/Home/Home_page.dart';
import 'package:gerenciamento_loja/src/app/pages/login/components/input_field/input_field_widget.dart';
import 'package:gerenciamento_loja/src/app/pages/login/login_bloc.dart';
import 'package:gerenciamento_loja/src/app/shared/enums/login_enum.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _loginBloc = AppModule.to.getBloc<LoginBloc>();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      print(state);
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=>HomePage())
          );
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.INITIAL,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),
                );
              default:
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(),
                    SingleChildScrollView(
                        child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.pinkAccent,
                            size: 160,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: "Usuário",
                            obscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changeEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: "Senha",
                            obscure: true,
                            stream: _loginBloc.outPasword,
                            onChanged: _loginBloc.changePassword,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValue,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.pinkAccent,
                                    child: Text("Entrar"),
                                    onPressed: snapshot.hasData
                                        ? _loginBloc.submit
                                        : null,
                                    textColor: Colors.white,
                                    disabledColor:
                                        Colors.pinkAccent.withAlpha(140),
                                  ),
                                );
                              })
                        ],
                      ),
                    )),
                  ],
                );
            }
          }),
    );
  }
}
