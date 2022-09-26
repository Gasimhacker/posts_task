import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

final _fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class PostsScreen extends StatefulWidget {
  static const String id = 'PostsScreen';

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final postController = TextEditingController();
  String post = '';
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    getCurrentUser();
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
                    decoration: InputDecoration(
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
                        padding: EdgeInsets.only(
                          right: 0,
                        ),
                        title: 'Post',
                        color: KThemeColor,
                        onPressed: () async {
                          postController.clear();
                          await _fireStore.collection('users').add({
                            'post': post,
                            'username': loggedInUser?.email,
                          });
                          await _fireStore.collection('users').add({
                            'username': loggedInUser,
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 9,
              thickness: 8,
              color: Colors.grey,
            ),
            PostsStream(),
          ],
        ),
      ),
    );
  }
}

class Post extends StatelessWidget {
  final postContent;
  final userName;
  Post({this.postContent, this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                AnonymousAvatar(
                  backgroundColor: KThemeColor,
                  radius: 20,
                  iconColor: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${postContent}',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'comments',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {},
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.grey[600],
                    ),
                  ),
                  label: Text(
                    'comment',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class PostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Widget> posts = [];
          final users = snapshot.data?.docs;
          for (var user in users!) {
            final Map userMap = user.data() as Map;
            final postContent = userMap['post'];
            final username = userMap['username'];
            final postWidget = Post(
              userName: username,
              postContent: postContent,
            );
            posts.add(postWidget);
            posts.add(Divider(
              height: 9,
              thickness: 8,
              color: Colors.grey,
            ));
          }
          return Expanded(
              child: ListView(
            children: posts,
          ));
        });
  }
}
