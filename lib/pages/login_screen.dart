import 'package:flutter/material.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/pages/PostsScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const AnonymousAvatar(),
            const SizedBox(height: 30),
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Email Address',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                ),
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
              ),
            ),
            LoginRegisterButton(
              route: PostsScreen.id,
              title: 'Login',
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 90),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email!, password: password!);
                  if (newUser != null) {
                    Navigator.pushNamed(context, PostsScreen.id);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                } on FirebaseAuthException catch (e) {
                  // Display something when auth error happens
                  setState(() {
                    showSpinner = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? e.code),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
