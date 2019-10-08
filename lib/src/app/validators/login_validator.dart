import 'dart:async';

class LoginValidator {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) async {
      if (RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) sink.add(email);
      else sink.addError('Insira um email valido');
    },
  );
    final validatePass = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) async {
      if (pass.length >= 4) sink.add(pass);
      else sink.addError('Senha inválida! Senha deve conter pelo menos 4 caracters');
    },
  );
}
