import 'package:flutter/material.dart';
import 'package:test_dynamiclink_issue/screens/entry_point.dart';
import 'package:test_dynamiclink_issue/screens/home.dart';

class VerifyNewEmailSuccessArguments {
  final String email;
  final String previousEmail;

  VerifyNewEmailSuccessArguments({
    @required this.email,
    @required this.previousEmail,
  });
}

class VerifyNewEmailSuccess extends StatelessWidget {
  static String id = "verifynewemailsuccess";
  @override
  Widget build(BuildContext context) {
    final VerifyNewEmailSuccessArguments args =
        ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Verify New Email Success"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your previous email, " +
                  args?.previousEmail +
                  " is now replaced with " +
                  args?.email +
                  "."),
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
