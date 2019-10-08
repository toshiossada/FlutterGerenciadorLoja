import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/app_module.dart';
import 'package:gerenciamento_loja/src/app/components/imagesWidget/image_source_sheet/image_source_sheet_widget.dart';

import 'edit_category_dialog_bloc.dart';

class EditCategoryDialogWidget extends StatefulWidget {
  DocumentSnapshot category;
  EditCategoryDialogWidget({@required this.category});

  @override
  _EditCategoryDialogWidgetState createState() =>
      _EditCategoryDialogWidgetState(category: category);
}

class _EditCategoryDialogWidgetState extends State<EditCategoryDialogWidget> {
  final EditCategoryDialogBloc _categoryBloc;
  final TextEditingController _controller;

  _EditCategoryDialogWidgetState({@required DocumentSnapshot category})
      : _categoryBloc = AppModule.to.getBloc<EditCategoryDialogBloc>()
          ..init(category),
        _controller = TextEditingController(
            text: category != null ? category.data['title'] : '');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheetWidget(
                            onImageSelected: (image) {
                              Navigator.pop(context);
                              _categoryBloc.setImage(image);
                            },
                          ));
                },
                child: StreamBuilder(
                  stream: _categoryBloc.outImages,
                  builder: (context, snapshot) {
                    if (snapshot.data != null)
                      return CircleAvatar(
                        child: snapshot.data is File
                            ? Image.file(snapshot.data, fit: BoxFit.cover)
                            : Image.network(snapshot.data, fit: BoxFit.cover),
                        backgroundColor: Colors.transparent,
                      );
                    else
                      return Icon(Icons.image);
                  },
                ),
              ),
              title: StreamBuilder(
                stream: _categoryBloc.outTitle,
                builder: (context, s) => TextField(
                  controller: _controller,
                  onChanged: _categoryBloc.setTitle,
                  decoration:
                      InputDecoration(errorText: s.hasError ? s.error : null),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                  stream: _categoryBloc.outDelete,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container();
                    else
                      return FlatButton(
                        child: Text('Excluir'),
                        textColor: Colors.red,
                        onPressed: snapshot.data ? () {
                          _categoryBloc.delete();
                          Navigator.pop(context);
                        } : null,
                      );
                  },
                ),
                StreamBuilder<bool>(
                  stream: _categoryBloc.submitValid,
                  builder: (context, s) => FlatButton(
                    child: Text('Salvar'),
                    onPressed: s.hasData ? () async {
                      await _categoryBloc.savaData();
                      Navigator.pop(context);
                    } : null,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
