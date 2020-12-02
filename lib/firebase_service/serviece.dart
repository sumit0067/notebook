import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notebook/screen/dashBoard.dart';
import 'package:notebook/screen/login.dart';

class Manager {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  addUser(uid, data, context,error) {
    fireStore
        .collection('user')
        .doc(uid)
        .collection('userDetails')
        .doc()
        .set(data)
        .then((value) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LogIn(),
                ),
              ),
            }).catchError((e){
              e=error.message;
    });
  }

  addNote(uid, data, context) {
    fireStore
        .collection('user')
        .doc(uid)
        .collection('noteDetails')
        .doc()
        .set(data)
        .then((value) => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => DashBoard()))
            })
        .catchError(
      (e) {
        print(e);
      },
    );
  }

  Stream<QuerySnapshot> getUserData(BuildContext context) async* {
    final id = FirebaseAuth.instance.currentUser.uid;
    yield* FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('userDetails')
        .snapshots();
  }
}
