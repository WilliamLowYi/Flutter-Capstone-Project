import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();

  var password = '',
      email = '',
      confirmPassword = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
      String text, Color? color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 18.0),),
      backgroundColor: color,
    ));
  }

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email, password: password);
      print(userCredential);

      mySnackBar('Registered Successfully. Please Sign In', Colors.green);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('Password is too weak');
        mySnackBar('Password is too weak', Colors.redAccent);
      } else if (error.code == 'email-already-in-use') {
        print('Account already exist');
        mySnackBar('Account already exist', Colors.redAccent);
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Form(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: ListView(
              children: [
                // Email
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 18.0),
                    ),
                    autofocus: false,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email.';
                      } else if (!value.contains('@')) {
                        return 'Please Input Valid Email.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                // Password
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 18.0),
                      // border: OutlineInputBorder(),
                    ),
                    autofocus: false,
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                // Confirm Password
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontSize: 18.0),
                      // border: OutlineInputBorder(),
                    ),
                    autofocus: false,
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      } else if (password != confirmPassword) {
                        return 'Please Match Your Password $password @ $confirmPassword';
                      } else {
                        return null;
                      }
                    },
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),
                // SignUp Button
                Container(
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text.trim();
                                password = passwordController.text.trim();
                                confirmPassword =
                                    confirmPasswordController.text.trim();
                              });
                            }
                            registration();
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                // Login Page Button
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                    animation2) => LoginPage(),
                                transitionDuration: Duration(seconds: 0)));
                          },
                          child: Text('Login'),
                        )
                      ],
                    )
                )
              ],
            ),
          ),
          key: _formKey,
        ),
        backgroundColor: Colors.white,
      );
    }
}


