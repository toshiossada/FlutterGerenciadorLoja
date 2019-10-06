import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/pages/login/validators/Login_validator.dart';
import 'package:gerenciamento_loja/src/app/repositories/login_repository.dart';
import 'package:gerenciamento_loja/src/app/shared/enums/login_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LoginBloc extends BlocBase with LoginValidator {
  var _loginRepository = AppModule.to.getDependency<LoginRepository>();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  get outEmail => _emailController.stream.transform(validateEmail);
  get outPasword => _passwordController.stream.transform(validatePass);
  get outState => _stateController.stream;

  Stream<bool> get outSubmitValue =>
      Observable.combineLatest2(outEmail, outPasword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc() {
    
    registerListens();
  }

  registerListens() {
    _streamSubscription =
        _loginRepository.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          _loginRepository.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  submit() async {
    FirebaseAuth.instance.signOut();
    final email = _emailController.value;
    final pass = _passwordController.value;

    _stateController.add(LoginState.LOADING);
    try {
      var user = await _loginRepository.login(email: email, pass: pass);

      // if (user != null) {
      //   if (await verifyPrivileges(user.user)) {
      //     _stateController.add(LoginState.SUCCESS);
      //   } else {
      //     _loginRepository.instance.signOut();
      //     _stateController.add(LoginState.FAIL);
      //   }
      // } else {
      //   _stateController.add(LoginState.IDLE);
      // }

      return user;
         
    } catch (e) {
      print(e);
      return _stateController.add(LoginState.FAIL);
    }
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    try {
      var doc = await _loginRepository.verifyPrivileges(user);
      if (doc.data != null)
          return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _streamSubscription.cancel();

    super.dispose();
  }
}
