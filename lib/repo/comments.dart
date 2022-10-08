import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/components/comment_ui.dart';
import 'package:posts_task/repo/auth.dart';

final _fireStore = FirebaseFirestore.instance;
final loggedInUser = CreateAndSignUser().getCurrentUser();

abstract class Comments {
  void addComment(
    String comment,
    String postId,
  );
  Widget showComments(AsyncSnapshot<QuerySnapshot> snapshot, String postId);
}

class CommentsFunctionality extends Comments {
  @override
  Future<void> addComment(String comment, String postId) async {
    await _fireStore
        .collection('postWithComments')
        .doc(postId)
        .collection(postId)
        .add({
      'comment': comment,
      'commenter': loggedInUser?.email,
    });
  }

  @override
  Widget showComments(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String postId) {
    if (snapshot.hasData) {
      final commentsDocs = snapshot.data!.docs;
      List<Comment> commentsList = [];
      for (var commentDoc in commentsDocs) {
        final Map commentMap = commentDoc.data() as Map;
        final commentContent = commentMap['comment'];
        final commenter = commentMap['commenter'];
        final commentId = commentDoc.id;
        bool isDeleteCommentVisible = false;

        if (commenter == loggedInUser!.email) {
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
  }
}

class MockCommentsFunctionality extends Comments {
  @override
  Future<void> addComment(String comment, String postId) async {
    await _fireStore
        .collection('postWithComments')
        .doc(postId)
        .collection(postId)
        .add({
      'comment': comment,
      'commenter': loggedInUser?.email,
    });
  }

  @override
  Widget showComments(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String postId) {
    if (snapshot.hasData) {
      final commentsDocs = snapshot.data!.docs;
      List<Comment> commentsList = [];
      for (var commentDoc in commentsDocs) {
        final Map commentMap = commentDoc.data() as Map;
        final commentContent = commentMap['comment'];
        final commenter = commentMap['commenter'];
        final commentId = commentDoc.id;
        bool isDeleteCommentVisible = false;

        if (commenter == loggedInUser!.email) {
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
  }
}
