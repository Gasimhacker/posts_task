import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/repo/auth.dart';
import 'package:posts_task/repo/posts.dart';

final _fireStore = FirebaseFirestore.instance;

class PostsScreen extends StatefulWidget {
  static const String id = 'PostsScreen';
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final postController = TextEditingController();
  String post = '';
  User? loggedInUser;
  @override
  void initState() {
    loggedInUser = CreateAndSignUser().getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Card(
              elevation: 0,
              child: Column(
                children: [
                  TextField(
                    controller: postController,
                    onChanged: (value) {
                      post = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind ?',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LoginRegisterButton(
                          padding: const EdgeInsets.only(
                            right: 0,
                          ),
                          title: 'Post',
                          color: kThemeColor,
                          onPressed: () async {
                            postController.clear();
                            await PostsFunctionality()
                                .addPost(loggedInUser!, post);
                          }),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 9,
              thickness: 8,
              color: Colors.grey,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('postWithComments').snapshots(),
                builder: (context, snapshot) {
                  return PostsFunctionality().showPosts(snapshot, loggedInUser);
                }),
          ],
        ),
      ),
    );
  }
}
