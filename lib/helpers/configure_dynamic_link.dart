import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:test_dynamiclink_issue/helpers/double_call_filter.dart';
import 'package:test_dynamiclink_issue/screens/verify_email_success.dart';
import 'package:test_dynamiclink_issue/screens/verify_new_email_success.dart';

class ConfigureDynamicLink {
  ConfigureDynamicLink._privateConstructor();

  FirebaseDynamicLinks _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final ConfigureDynamicLink _instance =
      ConfigureDynamicLink._privateConstructor();

  static ConfigureDynamicLink get instance => _instance;

  bool _isConfigured = false;

  Future<void> configureFirebaseDynamicLink(
    BuildContext context,
  ) async {
    _firebaseDynamicLinks.onLink(
      onSuccess: DoubleCallFilter<PendingDynamicLinkData>(
        action: (dynamicLink) async {
          await _onSuccessDynamicLink(
            context,
            dynamicLink,
          );
        },
      ),
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );

    if (!_isConfigured) {
      final PendingDynamicLinkData dynamicLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (dynamicLink != null) {
        await _onSuccessDynamicLink(
          context,
          dynamicLink,
        );
      }
      _isConfigured = true;
    }
  }

  Future<void> _onSuccessDynamicLink(
    BuildContext context,
    PendingDynamicLinkData dynamicLink,
  ) async {
    try {
      final Uri deepLink = dynamicLink?.link;
      String email;
      String previousEmail;

      if (deepLink == null) {
        print("No deeplink found");
        return null;
      }

      if (deepLink.queryParameters.containsKey("oobCode")) {
        final String code = deepLink.queryParameters["oobCode"];
        try {
          final ActionCodeInfo info = await _firebaseAuth.checkActionCode(code);
          print("----- info.data -------");
          print(info.data.toString());
          email = info.data["email"];
          previousEmail = info.data["previousEmail"];
          await _firebaseAuth.applyActionCode(code);
        } catch (e, s) {
          print(e);
          print(s);
        }
      }

      if (deepLink.queryParameters.containsKey("continueUrl")) {
        final Uri continueUrl = Uri.parse(
          Uri.decodeComponent(
            deepLink.queryParameters["continueUrl"],
          ),
        );
        if (continueUrl.fragment == VerifyEmailSuccess.id) {
          Navigator.pushNamed(
            context,
            continueUrl.fragment,
            arguments: VerifyEmailSuccessArguments(
              email: email,
            ),
          );
          return null;
        }
        if (continueUrl.fragment == VerifyNewEmailSuccess.id) {
          Navigator.pushNamed(
            context,
            continueUrl.fragment,
            arguments: VerifyNewEmailSuccessArguments(
              email: email,
              previousEmail: previousEmail,
            ),
          );
          return null;
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    return null;
  }
}
