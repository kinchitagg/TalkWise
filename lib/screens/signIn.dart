import 'package:chatar_patar/helper/sharedpreferences.dart';
import 'package:chatar_patar/screens/chatRoom.dart';
import 'package:chatar_patar/services/auth.dart';
import 'package:chatar_patar/services/database.dart';
import 'package:chatar_patar/shared/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function() callBack;

  const SignIn({Key key, this.callBack}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot snapshot;

  signMeIn() {
    if (_formKey.currentState.validate()) {
      print("signing in");
      setState(() {
        isLoading = true;
      });
      authService
          .signInwithEmailandPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        print(value.uid);
        if (value.uid != null) {
          HelperFunction.saveUserLoginKeySharedPreferences(true);
          HelperFunction.saveEmailSharedPreferences(_emailController.text);
          databaseService.getUserInfobyEmail(_emailController.text).then((val) {
            snapshot = val;
            HelperFunction.saveUsernameSharedPreferences(
                snapshot.documents[0].data["Username"]);
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
        } else
          print("login failed");
      });
    }
  }

  signInwithGoogle() {
    print("signing in");
    // setState(() {
    //   isLoading = true;
    // });
    authService.signInWithGoogle().then((value) {
      print(value.displayName);
      List<String> name = value.displayName.toString().split(" ");
      print(name[0]);
      print(value.email);
      if (value.uid != null) {
        HelperFunction.saveUsernameSharedPreferences(
            name[0]);
        HelperFunction.saveEmailSharedPreferences(value.email.toString());
        HelperFunction.saveUserLoginKeySharedPreferences(true);
          Map<String, String> userInfoMap = {
            "Username": name[0],
            "Email": value.email.toString()
          };
          databaseService.uploadUserInfo(userInfoMap);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
          
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Talk Wise",
                style: TextStyle(fontSize: 30),
              ),
            ),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 120,
                alignment: Alignment.bottomCenter,
                child: Container(
                  // margin: EdgeInsets.only(top:50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 0.0, right: 30, left: 30, bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black87),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Please enter your Email and Password",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      controller: _emailController,
                                      validator: (val) {
                                        return RegExp(
                                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                .hasMatch(val)
                                            ? null
                                            : "Provide a valid email address";
                                      },
                                      decoration:
                                          textformFieldDecoration("Email")
                                              .copyWith(
                                                  prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Colors.black,
                                      )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      style: TextStyle(color: Colors.black),
                                      validator: (val) {
                                        return val.isEmpty || val.length <= 6
                                            ? "Password can't be empty"
                                            : null;
                                      },
                                      controller: _passwordController,
                                      decoration:
                                          textformFieldDecoration("Password")
                                              .copyWith(
                                                  prefixIcon: Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.black)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeIn();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [Colors.blue[300], Colors.blue],
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => signInwithGoogle(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In with Google",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "First Time ? ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    widget.callBack();
                                  },
                                  child: Text(
                                    "SignUp ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ))
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
