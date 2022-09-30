import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posts_task/components/post_ui.dart';
import 'package:posts_task/components/login_register.dart';
import 'package:posts_task/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:posts_task/services/models.dart';

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
                          await _fireStore.collection('postWithComments').add({
                            'poster': loggedInUser?.email,
                            'post': post,
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

class PostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('postWithComments').snapshots(),
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
            final username = userMap['poster'];
            var postId = user.id;

            final postWidget = Post(
              postId: postId,
              addCommentFunctionality: (comment, commentController) async {
                commentController.clear();
                await _fireStore
                    .collection('postWithComments')
                    .doc(postId)
                    .collection(postId)
                    .add({
                  'comment': comment,
                  'commenter': loggedInUser?.email,
                });
              },
              onDeletePressed: () async {
                await _fireStore
                    .collection('postWithComments')
                    .doc(postId)
                    .delete();
              },
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
