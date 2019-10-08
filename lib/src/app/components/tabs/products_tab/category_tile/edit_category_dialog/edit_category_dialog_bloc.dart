import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class EditCategoryDialogBloc extends BlocBase {
  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  File image;
  String title;

  Stream<String> get outTitle => _titleController.stream
          .transform(StreamTransformer<String, String>.fromHandlers(
        handleData: (title, sink) {
          if (title.isEmpty)
            sink.addError('Insira um titulo');
          else
            sink.add(title);
        },
      ));
  Stream get outImages => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;
  Stream<bool> get submitValid =>
      Observable.combineLatest2(outTitle, outImages, (a, b) => true);

  DocumentSnapshot category;
  init(DocumentSnapshot c) {
    category = c;

    if (category != null) {
      title = category.data['title'];
      image = category.data['icon'];

      _titleController.add(category.data['title']);
      _imageController.add(category.data['icon']);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  setImage(File file) {
    image = file;
    _imageController.add(file);
  }

  setTitle(String title) {
    this.title = title;

    _titleController.add(title);
  }

  savaData() async {
    if (image == null && category == null && title == category.data['title'])
      return;
    Map<String, dynamic> dataToUpdate = {};

    if (image != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('icons')
          .child(title)
          .putFile(image);
      StorageTaskSnapshot snap = await task.onComplete;

      dataToUpdate['icon'] = await snap.ref.getDownloadURL();
    }
    if (category == null || title != category.data['title']) {
      dataToUpdate['title'] = title;
    }

    if (category == null) {
      await Firestore.instance
          .collection('products')
          .document(title.toLowerCase())
          .setData(dataToUpdate);
    } else {
      await category.reference.updateData(dataToUpdate);
    }
  }

  delete(){
    category.reference.delete();
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteController.close();
    super.dispose();
  }
}
