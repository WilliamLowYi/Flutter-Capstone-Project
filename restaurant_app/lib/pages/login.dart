import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/myLibrary/database_access_object.dart';
import 'package:restaurant_app/myLibrary/methods.dart';
import 'package:restaurant_app/pages/forgot_password.dart';
import 'package:restaurant_app/pages/sign_up.dart';
import 'package:restaurant_app/pages/main_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // https://flutter.dev/docs/cookbook/forms/validation
  // A global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  // https://flutter.dev/docs/cookbook/forms/text-field-changes
  // Create a text controller and connect to text field.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final DatabaseAccess _database = DatabaseAccess();
  final Methods _myMethods = Methods();

  late bool isRestaurantAccount;


  // https://firebase.flutter.dev/docs/auth/usage#sign-in
  userLogin() async {
    await checkAccount();
    if (isRestaurantAccount) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password
        );
        // https://flutter.dev/docs/cookbook/navigation/navigation-basics#2-navigate-to-the-second-route-using-navigatorpush
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage(email)));
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found' || error.code == 'wrong-password') {
          print('Invalid Log In');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Incorrect Email or Password',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ));
        }
      }
    } else {
      _myMethods.mySnackBar('Invalid Log In. Make sure your are from restaurant partner', Colors.red, context);
    }
  }

  // Search in Realtime Database for given email address
  checkAccount() {
    String email = this.email;
    if (email.contains('.')) {
      email = email.replaceAll('.', '-');
    }
    String userPath = 'user/$email/type';
    _database.getDatabaseReference().child(userPath).once().then((snapshot) {
      final accountType = snapshot.value;
      print(snapshot.value);
      if (accountType == 'restaurant') {
        setState(() {
          isRestaurantAccount = true;
        });
      } else {
        setState(() {
          isRestaurantAccount = false;
        });
      }
    });
  }



  // https://flutter.dev/docs/cookbook/forms/text-field-changes#create-a-texteditingcontroller
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: ListView(
            children: [
              // Image
              Container(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset("images/login.jpg"),
              ),
              // Email Text Field
              Container(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 17.0
                    ),
                    border: OutlineInputBorder(),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')){
                      return 'Please Enter Valid Email.';
                    } else {
                      return null;
                    }
                  },
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              // Password Text Field
              Container(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        fontSize: 17.0
                    ),
                    border: OutlineInputBorder(),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Please Enter Password.';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              // Login & Forget Password Buttons
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        // https://flutter.dev/docs/cookbook/forms/validation#how-does-this-work
                        // Validate returns true if the form is valid(validator on each text field) for each text field in the form, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          userLogin();
                        }
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Forget Password',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                    )
                  ],
                ),
              ),
              // Sign Up
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
      ),
    );
  }
}
