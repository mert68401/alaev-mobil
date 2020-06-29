import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddNewAdvScreen extends StatefulWidget {
  static const routeName = "add-new-advertisement";

  @override
  _AddNewAdvScreenState createState() => _AddNewAdvScreenState();
}

class _AddNewAdvScreenState extends State<AddNewAdvScreen> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print(_image);
      });
    }

    Future uploadPicture(BuildContext ctx) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      print(uploadTask);
      print(firebaseStorageRef);

      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Yeni İlan Ekle"),
        ),
        body: Column(
          children: <Widget>[
            _image == null
                ? Text("boş")
                : Image.file(
                    _image,
                    width: 500,
                    height: 500,
                  ),
            IconButton(icon: Icon(Icons.add_a_photo), onPressed: getImage),
            IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: () => uploadPicture(context)),
          ],
        ));
  }
}
