import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/module/noteModule.dart';
import 'package:notebook/screen/addNote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> getNoteData(BuildContext context) async* {
    final id = FirebaseAuth.instance.currentUser.uid;
    yield* FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('noteDetails')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder(
          stream: getNoteData(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            getList(context, snapshot.data.docs[index]),
                          ],
                        ),
                      ));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoteData()));
        },
      ),
    );
  }

  Widget getList(BuildContext context, DocumentSnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () {
          var id = snapshot.id;
          var title = snapshot.get('title');
          var des = snapshot.get('description');
          DateTime dateTime = snapshot.get('dateTime').toDate();
          var imageUrl = snapshot.get('imageUrl');
          NoteModule module = NoteModule(title, des, dateTime, imageUrl);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteData(module: module, id: id)),
          );
        },
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: snapshot.get('imageUrl') == 'empty'
                    ? NetworkImage(
                        'https://i.pinimg.com/736x/80/37/30/803730e547ac1ecc73d14a0cb1cf8795.jpg')
                    : NetworkImage(snapshot.get('imageUrl')),
              ),
              borderRadius: BorderRadius.circular(70),
              border: Border.all(color: Colors.white, width: 3)),
        ),
        title: Text(
          snapshot.get('title'),
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
        subtitle: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${DateFormat.yMMMd().format(snapshot.get('dateTime').toDate()).toString()}',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('user')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('noteDetails')
                .doc(snapshot.id)
                .delete();
          },
          color: Colors.white,
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
