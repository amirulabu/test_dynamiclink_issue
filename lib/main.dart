import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dynamiclink_issue/screens/change_email.dart';
import 'package:test_dynamiclink_issue/screens/entry_point.dart';
import 'package:test_dynamiclink_issue/screens/home.dart';
import 'package:test_dynamiclink_issue/screens/sign_in.dart';
import 'package:test_dynamiclink_issue/screens/sign_up.dart';
import 'package:test_dynamiclink_issue/screens/verify_email_success.dart';
import 'package:test_dynamiclink_issue/screens/verify_new_email_success.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance.userChanges(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          EntryPoint.id: (_) => EntryPoint(),
          SignIn.id: (_) => SignIn(),
          SignUp.id: (_) => SignUp(),
          Home.id: (_) => Home(),
          VerifyEmailSuccess.id: (_) => VerifyEmailSuccess(),
          ChangeEmail.id: (_) => ChangeEmail(),
          VerifyNewEmailSuccess.id: (_) => VerifyNewEmailSuccess()
        },
        home: EntryPoint(),
      ),
    );
  }
}
