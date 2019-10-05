import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final bool obscure;
  final String hint;
  final Stream<String> stream;
  final Function(String) onChanged;

  InputField(
      {@required this.icon,
      @required this.hint,
      @required this.obscure,
      @required this.stream,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pinkAccent),
            ),
            contentPadding:
                EdgeInsets.only(left: 5, top: 30, bottom: 30, right: 30),
            errorText: snapshot.hasError ? snapshot.error : null,
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
        );
      },
    );
  }
}
