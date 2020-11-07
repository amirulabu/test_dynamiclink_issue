import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_dynamiclink_issue/screens/sign_up.dart';

class SignIn extends StatefulWidget {
  static String id = "signin";
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Visibility(
                    visible: _isLoading,
                    child: Text("Loading..."),
                    replacement: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("Sign in"),
                      onPressed: () async {
                        await _handleClickSignIn(context);
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text("Sign up a new account"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        SignUp.id,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClickSignIn(context) async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigator.pushNamed(context, EntryPoint.id);
    } catch (e, s) {
      print(e);
      print(s);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
