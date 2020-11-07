import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dynamiclink_issue/helpers/configure_dynamic_link.dart';
import 'package:test_dynamiclink_issue/screens/change_email.dart';
import 'package:test_dynamiclink_issue/screens/entry_point.dart';
import 'package:test_dynamiclink_issue/screens/verify_email_success.dart';

class Home extends StatefulWidget {
  static String id = "home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final cfdl = ConfigureDynamicLink.instance;

  String email = FirebaseAuth.instance.currentUser.email;
  bool emailVerified = FirebaseAuth.instance.currentUser.emailVerified;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await cfdl.configureFirebaseDynamicLink(context);
      // await FirebaseAuth.instance.currentUser.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Home"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: " + email),
              Text(
                "Email verified: " + emailVerified.toString(),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, EntryPoint.id);
                },
                child: Text("Sign out"),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                onPressed: () async {
                  await _handleClickSendEmailVerification(context);
                },
                child: Text("Send email verification"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChangeEmail.id);
                },
                child: Text("Change email"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _handleClickSendEmailVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser.sendEmailVerification(
        ActionCodeSettings(
          url: "https://mirul-learning-dev.web.app/#" + VerifyEmailSuccess.id,
          androidPackageName: "xyz.mirul.testdynamiclinkissue",
          handleCodeInApp: true,
        ),
      );
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Verification email sent"),
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
  }
}
