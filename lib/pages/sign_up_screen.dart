import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/pages/posts_screen.dart';
import 'package:posts_task/spinner.dart';
import 'package:posts_task/repo/auth.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Spinner>(context).isSpinning,
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
              onPressed: () {
                CreateAndSignUser().createUser(
                  email,
                  password,
                  context,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
