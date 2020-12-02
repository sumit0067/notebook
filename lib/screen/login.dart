import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file:///C:/Users/Sumit/Desktop/FlutterEx/ex/notebook/lib/screen/signup.dart';

import 'dashBoard.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _key = GlobalKey<FormState>();
  bool remember = false;
  String _email, _password, id, error;
  FirebaseAuth _auth = FirebaseAuth.instance;

  login() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      await _auth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((_) async {
        id = _auth.currentUser.uid;
        if (remember == true) {
          SharedPreferences data = await SharedPreferences.getInstance();
          data.setString('id', id);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashBoard()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashBoard()));
        }
      }).catchError((e) {
        setState(() {
          error = e.message;
        });
      });
    }
  }

  Widget showError() {
    if (error != null) {
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
                child: AutoSizeText(error,
                    style: TextStyle(color: Colors.white), maxLines: 3)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      error = null;
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_outlined),
          title: Text("Sign In"),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              showError(),
              SizedBox(height: height * 0.02),
              Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Sign in with email and password \n or continue with social media',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 70,
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      //email
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter your Email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _email = value,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter Your Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                            child: Icon(
                              Icons.mail_outline,
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10),
                          focusedErrorBorder: OutlineInputBorder(
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

                      //password
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter your Email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _password = value,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter Your Password",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10),
                          focusedErrorBorder: OutlineInputBorder(
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
                      Row(
                        children: [
                          Checkbox(
                              value: remember,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  remember = value;
                                });
                              }),
                          Text('Remember Me'),
                          Spacer(),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
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
                    onPressed: login,
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
              SizedBox(height: 25),

              //social Media
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google-icon.svg',
                    height: 22,
                    width: 22,
                  ),
                  SizedBox(width: 20),
                  SvgPicture.asset(
                    'assets/icons/facebook-2.svg',
                    height: 22,
                    width: 22,
                  ),
                  SizedBox(width: 20),
                  SvgPicture.asset(
                    'assets/icons/twitter.svg',
                    height: 22,
                    width: 22,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account ?',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
