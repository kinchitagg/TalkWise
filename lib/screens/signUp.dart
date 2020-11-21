import 'package:chatar_patar/helper/sharedpreferences.dart';
import 'package:chatar_patar/screens/chatRoom.dart';
import 'package:chatar_patar/services/auth.dart';
import 'package:chatar_patar/services/database.dart';
import 'package:chatar_patar/shared/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function() callBack;

  const SignUp({Key key, this.callBack}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  //String _error ="";
  AuthService _authService = new AuthService();
  DatabaseService _databaseService = new DatabaseService();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void signUp() {
    if (_formKey.currentState.validate()) {
      print("signing up");

      setState(() {
        isLoading = true;
      });
      HelperFunction.saveUsernameSharedPreferences(_usernameController.text);
      HelperFunction.saveEmailSharedPreferences(_emailController.text);
      _authService
          .signUpwithEmailandPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
            print(value);
        if (value.uid != null) {
          HelperFunction.saveUserLoginKeySharedPreferences(true);
          Map<String, String> userInfoMap = {
            "Username": _usernameController.text,
            "Email": _emailController.text
          };
          _databaseService.uploadUserInfo(userInfoMap);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
        }else{
          print("here");
          setState(() {
            isLoading = false;
           // _error = value;
          });
          print(value.toString());
        }
      });

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: true,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Chatar Patar",
                style: TextStyle(fontSize: 30),
              ),
            ),
            body: SingleChildScrollView(
              //physics: NeverScrollableScrollPhysics(),
              //dragStartBehavior: DragStartBehavior.down,
              child: Container(
                height: MediaQuery.of(context).size.height - 120,
                alignment: Alignment.bottomCenter,
                child: Container(
                  // margin: EdgeInsets.only(top:50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //ShowError(error: _error),
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
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black87),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "To continue, you need to Sign up",
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
                                      controller: _usernameController,
                                      validator: (val) {
                                        return val.isEmpty || val.length <= 2
                                            ? "Username should be more than 2 character"
                                            : null;
                                      },
                                      decoration:
                                          textformFieldDecoration("Username")
                                              .copyWith(
                                                  prefixIcon: Icon(
                                                      Icons.person_outline,
                                                      color: Colors.black)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
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
                                                      color: Colors.black)),
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
                          signUp();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [Colors.blue[300], Colors.blue],
                              )),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      //   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "Sign In with Google",
                      //     style: TextStyle(color: Colors.black, fontSize: 18),
                      //   ),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(30),
                      //     color: Colors.white,
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have account ? ",
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
                                  )),
                              SizedBox(
                                height: 20,
                              ),
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
