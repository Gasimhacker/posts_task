import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/pages/posts_screen.dart';
import 'package:posts_task/spinner.dart';
import 'package:provider/provider.dart';

final _auth = FirebaseAuth.instance;

abstract class Auth {
  Future<Function> createUser(
      String email, String password, BuildContext context);
  Future<Function> signUser(
      String email, String password, BuildContext context);
  User? getCurrentUser();
}

class CreateAndSignUser extends Auth {
  @override
  Future<Function> createUser(
      String email, String password, BuildContext context) async {
    Provider.of<Spinner>(context, listen: false).changeSpinnerState();

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
      Provider.of<Spinner>(context, listen: false).changeSpinnerState();

      if (newUser != null) {
        Navigator.pushNamed(context, PostsScreen.id);
      }
    }
    throw UnimplementedError();
  }

  @override
  Future<Function> signUser(
      String email, String password, BuildContext context) async {
    Provider.of<Spinner>(context, listen: false).changeSpinnerState();

    UserCredential? newUser;

    try {
      newUser = await _auth.signInWithEmailAndPassword(
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
      Provider.of<Spinner>(context, listen: false).changeSpinnerState();

      if (newUser != null) {
        Navigator.pushNamed(context, PostsScreen.id);
      }
    }
    throw UnimplementedError();
  }

  @override
  User? getCurrentUser() {
    if (_auth.currentUser != null) {
      final loggedInUser = _auth.currentUser;
      return loggedInUser;
    }
    return null;
  }
}

class MockCreateAndSignUser extends Auth {
  @override
  Future<Function> createUser(
      String email, String password, BuildContext context) async {
    email = '$password@gmail.com';
    password = '123456789';
    Provider.of<Spinner>(context, listen: false).changeSpinnerState();

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
      Provider.of<Spinner>(context, listen: false).changeSpinnerState();

      if (newUser != null) {
        Navigator.pushNamed(context, PostsScreen.id);
      }
    }
    throw UnimplementedError();
  }

  @override
  Future<Function> signUser(
      String email, String password, BuildContext context) async {
    email = '$password@gmail.com';
    password = '123456789';
    Provider.of<Spinner>(context, listen: false).changeSpinnerState();

    UserCredential? newUser;

    try {
      newUser = await _auth.signInWithEmailAndPassword(
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
      Provider.of<Spinner>(context, listen: false).changeSpinnerState();

      if (newUser != null) {
        Navigator.pushNamed(context, PostsScreen.id);
      }
    }
    throw UnimplementedError();
  }

  @override
  User? getCurrentUser() {
    if (_auth.currentUser != null) {
      final loggedInUser = _auth.currentUser;
      return loggedInUser;
    }
    return null;
  }
}
