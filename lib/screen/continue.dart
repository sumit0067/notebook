import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook/firebase_service/serviece.dart';
import 'package:notebook/module/signupModul.dart';

class ContinueScreen extends StatefulWidget {
  final String email, password;

  ContinueScreen({Key key, this.email, this.password}) : super(key: key);

  @override
  _ContinueScreenState createState() =>
      _ContinueScreenState(this.email, this.password);
}

class _ContinueScreenState extends State<ContinueScreen> {
  String firstName, lastName, phone, state, uid, _error;
  final String email, password;

  _ContinueScreenState(this.email, this.password);

  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String id;
  String imageUrl = 'empty';
  FirebaseAuth _auth = FirebaseAuth.instance;

  signUp() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        id = _auth.currentUser.uid;
        SignUpModule module = SignUpModule(
            firstName, lastName, email, password, phone, state, imageUrl);
        Manager().addUser(id, module.toJson(), context,_error);
      }).catchError((e) {
        setState(() {
          _error = e.message;
        });
      });
    }
  }

  Widget showError() {
    if (_error != null) {
      return Container(
        height: 60,
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8, left: 3),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
                child: AutoSizeText(_error,
                    style: TextStyle(color: Colors.white), maxLines: 3)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _error = null;
                    });
                  }),
            )
          ],
        ),
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_outlined),
        title: Text("Sign Up"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showError(),
            Text(
              'Continue Profile',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),

            Text(
              'Complete your details or continue \n with social media ',
              textAlign: TextAlign.center,
            ),
            //form
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    //name
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Your First Name";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => firstName = value,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter Your First Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                      ),
                    ),
                    SizedBox(height: 20),
                    //lastName
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Your Last Name";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => lastName = value,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter Your Last Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                      ),
                    ),
                    SizedBox(height: 20),

                    //phone
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Your Phone Number";
                        } else if (value.length < 10) {
                          return 'Enter Valid Phone Number';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => phone = value,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter Your Phone",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Icon(
                            Icons.phone_iphone_sharp,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                      ),
                    ),
                    SizedBox(height: 20),

                    //state
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Your State";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => state = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter Your State",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10),
                      ),
                    ),
                    SizedBox(height: 20),
                    //button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: signUp,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, right: 25, top: 10),
                      child: Text(
                        'By continuing your confirm that you agree with our Term and Condition',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
