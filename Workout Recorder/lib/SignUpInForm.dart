// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
//
// class SignInUpForm extends StatefulWidget {
//   const SignInUpForm({super.key});
//
//   @override
//   State<SignInUpForm> createState() => _SignInUpFormState();
// }
//
// class _SignInUpFormState extends State<SignInUpForm> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   String? _firebaseErrorCode;
//
//   _onSignUp() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _usernameController.text,
//         password: _passwordController.text,
//       );
//       setState(() {
//         _firebaseErrorCode = null;
//       });
//     } on FirebaseAuthException catch (ex) {
//       print(ex.code);
//       print(ex.message);
//       setState(() {
//         _firebaseErrorCode = ex.code;
//       });
//     }
//   }
//
//   _onSignIn() {
//     FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: _usernameController.text,
//       password: _passwordController.text,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//           children: [
//             TextField(
//               controller: _usernameController,
//             ),
//             TextField(
//               controller: _passwordController,
//             ),
//             ElevatedButton(
//               child: const Text('Sign up'),
//               onPressed: _onSignUp,
//             ),
//             ElevatedButton(
//               child: const Text('Sign in'),
//               onPressed: _onSignIn,
//             ),
//             if(_firebaseErrorCode != null) Text(_firebaseErrorCode!)
//           ]
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInUpForm extends StatefulWidget {
  const SignInUpForm({super.key});

  @override
  State<SignInUpForm> createState() => _SignInUpFormState();
}

class _SignInUpFormState extends State<SignInUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _consentGiven = ValueNotifier<bool>(false);
  String? _firebaseErrorCode;

  _onSignUp() async {
    if (_consentGiven.value) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );
        setState(() {
          _firebaseErrorCode = null;
        });
      } on FirebaseAuthException catch (ex) {
        print(ex.code);
        print(ex.message);
        setState(() {
          _firebaseErrorCode = ex.code;
        });
      }
    }
  }

  _onSignIn() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                children: [
                  Checkbox(
                    value: _consentGiven.value,
                    onChanged: (value) {
                      setState(() {
                        _consentGiven.value = value!;
                      });
                    },
                  ),
                  const Text('I give consent to share recording points to other user'),
                ],
              );
            },
          ),
          ElevatedButton(
            child: const Text('Sign up'),
            onPressed: _onSignUp,
            ),
          ElevatedButton(
            child: const Text('Sign in'),
            onPressed: _onSignIn,
          ),
          if (_firebaseErrorCode != null) Text(_firebaseErrorCode!)
        ],
      ),
    );
  }
}


