import 'dart:developer';
import 'dart:io';
import 'package:ctoc/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'helper/dialogs.dart';
import 'homepage.dart';

class loginscreen extends StatefulWidget {
  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  _handleGoogleBtclick() {
    Dialogs.ShowProgressbar(context);
    _signInWithGoogle().then((User) async {
      Navigator.pop(context);
      if (User != null) {
        if ((await Api.UserExists())) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const homepage()),
          );
        } else {
          await Api.CreateUser().then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const homepage()),
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle()$e');
      Dialogs.ShowSnackbar(context, 'Somethig went wrong (no internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat app")),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            child: Text("SIGN IN WITH GOOGLE"),
            onPressed: (() {
              _handleGoogleBtclick();
              // if (User != null) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const homepage()),
              //   );
              // }
            }),
          ),
        ),
      ),
    );
  }
}
