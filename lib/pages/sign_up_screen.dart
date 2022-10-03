import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/pages/PostsScreen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
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
              title: 'Sign up',
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 90),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                UserCredential? newUser;

                try {
                  newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  // This will catch any exception from the authentication only
                  // Best ux practice is to display something when error happens
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? e.code),
                    ),
                  );
                } finally {
                  // This gets executed either when try failed or succeeded
                  setState(() {
                    showSpinner = false;
                  });

                  if (newUser != null) {
                    Navigator.pushNamed(context, PostsScreen.id);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
