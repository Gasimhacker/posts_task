import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/components/comment_ui.dart';

class CommentsBottomSheet extends StatelessWidget {
  final String postId;
  final _user = FirebaseAuth.instance.currentUser;
  final _fireStore = FirebaseFirestore.instance;
  CommentsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup(postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final commentsDocs = snapshot.data!.docs;
            List<Comment> commentsList = [];
            for (var commentDoc in commentsDocs) {
              final Map commentMap = commentDoc.data() as Map;
              final commentContent = commentMap['comment'];
              final commenter = commentMap['commenter'];
              final commentId = commentDoc.id;

              bool isDeleteCommentVisible = false;
              if (commenter == _user!.email) {
                isDeleteCommentVisible = true;
              }
              final commentWidget = Comment(
                isDeleteCommentVisible: isDeleteCommentVisible,
                comment: commentContent,
                commenter: commenter,
                onDeleteCommentPressed: () {
                  _fireStore
                      .collection('postWithComments')
                      .doc(postId)
                      .collection(postId)
                      .doc(commentId)
                      .delete();
                },
              );
              commentsList.add(commentWidget);
            }
            return ListView(
              children: commentsList,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
