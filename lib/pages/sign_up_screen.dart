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
      backgroundColor: KThemeColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            AnonymousAvatar(),
            SizedBox(height: 30),
            Padding(
              padding: KTextFieldPadding,
              child: TextField(
                decoration: KTextFieldDecoration.copyWith(
                  hintText: 'Email Address',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: KTextFieldPadding,
              child: TextField(
                decoration: KTextFieldDecoration.copyWith(
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  print('${email} ${password}');
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

                  if (newUser != null) {
                    Navigator.pushNamed(context, PostsScreen.id);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}