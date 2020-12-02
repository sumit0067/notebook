import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'continue.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email, password, _error;
  String uid;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  signUp() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContinueScreen(
            email: email,
            password: password,
          ),
        ),
      );
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_outlined),
        title: Text("Sign Up"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              Text(
                'Register Account',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Complete your details or continue \n with social media ',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.03),
              //form
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      //email
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Your email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          email = input;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter Your Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
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
                      SizedBox(height: 25),

                      //password
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Your password';
                          } else if (value.length < 6) {
                            return 'password length me be 6 character';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (input) {
                          password = input;
                        },
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
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
                      SizedBox(height: 25),

                      //rePassword
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Your RePassword';
                          } else if (value == password) {
                            return 'Enter Your check you password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'RePassword',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter Your RePassword",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
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
              SizedBox(height: 40),
              //social media
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google-icon.svg',
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 15),
                  SvgPicture.asset(
                    'assets/icons/facebook-2.svg',
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 15),
                  SvgPicture.asset(
                    'assets/icons/twitter.svg',
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'By continuing your confirm that you agree with our Term and Condition',
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
