import 'package:flutter/material.dart';
import 'package:test_dynamiclink_issue/screens/entry_point.dart';
import 'package:test_dynamiclink_issue/screens/home.dart';

class VerifyEmailSuccessArguments {
  final String email;

  VerifyEmailSuccessArguments({@required this.email});
}

class VerifyEmailSuccess extends StatelessWidget {
  static String id = "verifyemailsuccess";
  @override
  Widget build(BuildContext context) {
    final VerifyEmailSuccessArguments args =
        ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Verify Email Success"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your email, " + args.email + " is verified!"),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EntryPoint.id,
                  );
                },
                child: Text("Back to home"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
