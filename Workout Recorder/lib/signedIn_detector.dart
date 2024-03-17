import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignUpInForm.dart';
import 'package:firstapp/leaderBoard_page.dart';

class SignedInDetector extends StatelessWidget {
  const SignedInDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const SignInUpForm();
        }
        if(snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data == null) {
            return const SignInUpForm();
          }
          return LeaderboardWidget();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
