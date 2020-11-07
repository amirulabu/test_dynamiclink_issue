import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_dynamiclink_issue/screens/entry_point.dart';

class SignUp extends StatefulWidget {
  static String id = "signup";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter confirm password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords don't match.";
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
                      child: Text("Sign up"),
                      onPressed: () async {
                        await _handleClickSignUp(context);
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text("Sign in instead"),
                    onPressed: () {
                      Navigator.pop(
                        context,
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

  Future<void> _handleClickSignUp(context) async {
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
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushNamed(context, EntryPoint.id);
    } catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
