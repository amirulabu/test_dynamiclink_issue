import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dynamiclink_issue/screens/home.dart';
import 'package:test_dynamiclink_issue/screens/sign_in.dart';

class EntryPoint extends StatefulWidget {
  static String id = "entrypoint";

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);

    return (_user != null) ? Home() : SignIn();
  }
}
