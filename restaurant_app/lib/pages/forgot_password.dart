import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/myLibrary/methods.dart';
import 'package:restaurant_app/pages/login.dart';
import 'package:restaurant_app/pages/sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();

  var email = '';

  final emailController = TextEditingController();

  final Methods _myMethods = Methods();

  // Reset Password
  // https://firebase.google.com/docs/auth/android/manage-users#send_a_password_reset_email
  void resetPassword() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _myMethods.mySnackBar('Password Reset Email has been sent!', Colors.amber, context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('Email Validation Error');
        _myMethods.mySnackBar('Email Validation Error', Colors.amber, context);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: const Text(
                'Reset Link will be send to your email.',
                style: TextStyle(
                  fontSize: 20.0
                )
              ),
              margin: EdgeInsets.only(top: 25.0),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                autofocus: false,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please Valid Enter Email';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                        });
                        resetPassword();
                      }
                    },
                    child: const Text(
                      'Send Email',
                      style: TextStyle(fontSize: 20.0),
                    )
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 15.0),
                    )
                  )
                ],
              ),
            ),
            // https://api.flutter.dev/flutter/material/ElevatedButton-class.html
            Container(
              child: Row(
                children: [
                  Text('Do not have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context,a,b) => SignUp(),
                                transitionDuration: Duration(seconds: 0)
                            ),
                                (route) => false);
                      },
                      child: const Text(
                          'Sign Up'
                      )
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Reset Password'),),
      backgroundColor: Colors.white,
    );
  }
}
