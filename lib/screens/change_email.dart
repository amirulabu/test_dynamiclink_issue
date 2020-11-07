import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dynamiclink_issue/screens/verify_email_success.dart';
import 'package:test_dynamiclink_issue/screens/verify_new_email_success.dart';

class ChangeEmail extends StatefulWidget {
  static String id = "changeemail";
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _email;

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);
    _email = _user?.email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Email"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current Email: " + _email),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "New email",
                        ),
                        controller: _newEmailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter new email";
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
                          child: Text("Change"),
                          onPressed: () async {
                            await _handleClickChange(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClickChange(context) async {
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
        email: _email,
        password: _passwordController.text,
      );

      await _firebaseAuth.currentUser.verifyBeforeUpdateEmail(
        _newEmailController.text,
        ActionCodeSettings(
          url:
              "https://mirul-learning-dev.web.app/#" + VerifyNewEmailSuccess.id,
          androidPackageName: "xyz.mirul.testdynamiclinkissue",
          handleCodeInApp: true,
        ),
      );
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Verification email sent to " + _newEmailController.text),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
