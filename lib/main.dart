import 'package:flutter/material.dart';
import 'package:posts_task/pages/PostsScreen.dart';
import 'package:posts_task/pages/login_screen.dart';
import 'package:posts_task/pages/sign_up_screen.dart';
import 'package:posts_task/pages/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        PostsScreen.id: (context) => PostsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
