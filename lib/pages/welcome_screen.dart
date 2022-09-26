import 'package:flutter/material.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/pages/login_screen.dart';
import 'package:posts_task/pages/sign_up_screen.dart';
import 'package:posts_task/components/anonymous_avatar.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcomeScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: KThemeColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            AnonymousAvatar(),
            Center(
              child: Text(
                'Welcome',
                style: KWelcomeTextStyle,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            LoginRegisterButton(
              route: LoginScreen.id,
              title: 'Login',
            ),
            LoginRegisterButton(route: SignUpScreen.id, title: 'Create Account')
          ],
        ),
      ),
    );
  }
}
