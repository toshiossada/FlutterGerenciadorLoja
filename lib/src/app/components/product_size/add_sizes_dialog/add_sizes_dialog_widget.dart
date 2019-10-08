import 'package:flutter/material.dart';

class AddSizesDialogWidget extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _controller,

              ),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text('Add'),
                  textColor: Colors.pinkAccent,
                  onPressed: () {
                    Navigator.pop(context, _controller.text);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
