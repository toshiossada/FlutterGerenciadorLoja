import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/pages/login/login_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Slidy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.grey[850],
      ),
      home: LoginPage(),
    );
  }
}
