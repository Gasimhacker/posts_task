import 'package:flutter/material.dart';
import 'package:posts_task/pages/posts_screen.dart';
import 'package:posts_task/pages/login_screen.dart';
import 'package:posts_task/pages/sign_up_screen.dart';
import 'package:posts_task/pages/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:posts_task/spinner.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Spinner>(
      create: (BuildContext context) {
        return Spinner();
      },
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          PostsScreen.id: (context) => const PostsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
