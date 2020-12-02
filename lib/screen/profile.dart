import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook/module/signupModul.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEnabled = false;

  GlobalKey<FormState> _key = GlobalKey();
  String firstName, lastName, phone, state, email, password;
  String imageUrl, id;
  File image;
  SignUpModule module;
  var uid = FirebaseAuth.instance.currentUser.uid;
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  Stream<QuerySnapshot> getUserData() async* {
    final id = FirebaseAuth.instance.currentUser.uid;
    yield* FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .collection('userDetails')
        .snapshots();
  }

  editProfile() {
    setState(() {
      isEnabled = true;
    });
  }

  Future getImage() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    image = File(file.path);
    storeImage(image);
  }

  storeImage(File file) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('userProfile-$id');
    storageReference.putFile(file).onComplete.then(
      (value) async {
        var downloadUrl = await value.ref.getDownloadURL();
        setState(() {
          this.imageUrl = downloadUrl;
        });
        FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection('userDetails')
            .doc(id)
            .update(
          {'imageUrl': imageUrl},
        );
      },
    );
  }

  updateProfile(BuildContext context, id) {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      SignUpModule module = SignUpModule(
          firstController.text,
          lastController.text,
          emailController.text,
          passwordController.text,
          phoneController.text,
          stateController.text);

      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('userDetails')
          .doc(id)
          .update(module.toJson())
          .then((value) {
        setState(() {
          isEnabled = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editProfile();
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              updateProfile(context, id);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return profile(context, snapshot.data.docs[index]);
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget profile(BuildContext context, DocumentSnapshot document) {
    firstController.text = document.get('firstName');
    lastController.text = document.get('lastName');
    emailController.text = document.get('email');
    passwordController.text = document.get('password');
    phoneController.text = document.get('phone');
    stateController.text = document.get('state');
    id = document.id;
    imageUrl = document.get('imageUrl');

    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isEnabled
              ? Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: document.get('imageUrl') == 'empty'
                            ? NetworkImage(
                                'https://i.pinimg.com/736x/80/37/30/803730e547ac1ecc73d14a0cb1cf8795.jpg')
                            : NetworkImage(document.get('imageUrl')),
                      ),
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(color: Colors.black, width: 3)),
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: document.get('imageUrl') == 'empty'
                          ? NetworkImage(
                              'https://i.pinimg.com/736x/80/37/30/803730e547ac1ecc73d14a0cb1cf8795.jpg')
                          : NetworkImage(document.get('imageUrl').toString()),
                    ),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
          Text(
            '${document.get('firstName')} ${document.get('lastName')}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(height: 05),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Form(
              key: _key,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: Text(
                        'personal information',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        controller: firstController,
                        enabled: isEnabled,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        controller: lastController,
                        enabled: isEnabled,
                        onSaved: (value) => lastName = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'lastName',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        controller: emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        controller: phoneController,
                        enabled: isEnabled,
                        onSaved: (value) => phone = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'phone',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      child: TextFormField(
                        controller: stateController,
                        enabled: isEnabled,
                        onSaved: (value) => state = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'state',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      Positioned(
          right: MediaQuery.of(context).size.width / 3.1,
          top: 45,
          child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                size: 30,
                color: Theme.of(context).accentColor,
              ),
              onPressed: getImage)),
    ]);
  }
}

class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 140);
    path.lineTo(size.width, 00);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
