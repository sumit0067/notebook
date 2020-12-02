import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notebook/firebase_service/serviece.dart';
import 'package:notebook/module/noteModule.dart';
import 'package:notebook/screen/dashBoard.dart';

class NoteData extends StatefulWidget {
  final NoteModule module;
  final String id;

  NoteData({this.module, this.id});

  @override
  _NoteDataState createState() => _NoteDataState(this.module, this.id);
}

class _NoteDataState extends State<NoteData> {
  String uid, id, imageUrl = 'empty';
  GlobalKey<FormState> _key = GlobalKey();
  DateTime currentDate = DateTime.now();
  NoteModule module;

  _NoteDataState(
    this.module,
    this.id,
  );

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addNote() async {
    if (_key.currentState.validate()) {
      uid = FirebaseAuth.instance.currentUser.uid;
      NoteModule noteModule = NoteModule(titleController.text,
          descriptionController.text, currentDate, imageUrl);
      Manager().addNote(uid, noteModule.toJson(), context);
    }
  }

  Future getImage() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(file.path);
    storeImage(image);
  }

  storeImage(File file) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('noteImage-$uid');
    storageReference.putFile(file).onComplete.then((value) async {
      var downloadUrl = await value.ref.getDownloadURL();
      setState(() {
        this.imageUrl = downloadUrl;
      });
      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('NoteDetails')
          .doc(id)
          .update({'imageUrl': imageUrl}).then((value) {
        setState(() {
          imageUrl = module.imageUrl;
        });
      });
    });
  }

  datePicker() {
    showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime(DateTime.now().year + 50),
    ).then((date) {
      setState(() {
        currentDate = date;
      });
    });
  }

  updateNote() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      NoteModule noteModule = NoteModule(titleController.text,
          descriptionController.text, currentDate, imageUrl);
      uid = FirebaseAuth.instance.currentUser.uid;
      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('noteDetails')
          .doc(id)
          .update(noteModule.toJson())
          .then((_) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => DashBoard())));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(id == null ? 'Add Note' : 'Edit Note'),
          actions: [
            id == null
                ? Container()
                : IconButton(
                    onPressed: updateNote,
                    icon: Icon(
                      Icons.edit_outlined,
                    ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  id == null
                      ? GestureDetector(
                          onTap: getImage,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageUrl == null
                                      ? NetworkImage(
                                          'https://i.pinimg.com/736x/80/37/30/803730e547ac1ecc73d14a0cb1cf8795.jpg')
                                      : NetworkImage(imageUrl),
                                ),
                                borderRadius: BorderRadius.circular(70),
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: id == null
                                    ? NetworkImage(
                                        'https://i.pinimg.com/736x/80/37/30/803730e547ac1ecc73d14a0cb1cf8795.jpg')
                                    : NetworkImage(module.imageUrl),
                              ),
                              borderRadius: BorderRadius.circular(70),
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                        ),
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'enter your Note title';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        module.title = titleController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'title',
                      hintText: 'Note title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'enter your Note Description';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        module.description = descriptionController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Note Description ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: datePicker,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: id == null
                            ? DateFormat.yMMMd().format(currentDate)
                            : DateFormat().format(module.dateTime),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  id == null
                      ? RaisedButton(
                          onPressed: addNote,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Add Note',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ));
  }
}
