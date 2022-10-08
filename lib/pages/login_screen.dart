import 'package:flutter/material.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/pages/posts_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:posts_task/repo/auth.dart';
import 'package:provider/provider.dart';
import 'package:posts_task/spinner.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              title: 'Login',
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 90),
              onPressed: () {
                CreateAndSignUser().signUser(email, password, context);
              },
            )
          ],
        ),
      ),
    );
  }
}
