import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/components/post_ui.dart';

final _fireStore = FirebaseFirestore.instance;

abstract class Posts {
  void addPost(User loggedInUser, String post);
  Widget showPosts(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, User? loggedInUser);
}

class PostsFunctionality extends Posts {
  @override
  Future addPost(User loggedInUser, String post) async {
    await _fireStore.collection('postWithComments').add({
      'poster': loggedInUser.email,
      'post': post,
    });
    throw UnimplementedError();
  }

  @override
  Widget showPosts(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, User? loggedInUser) {
    if (!snapshot.hasData) {
      return const Center(
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
      bool isDeletePostVisible = false;
      if (username == loggedInUser!.email) {
        isDeletePostVisible = true;
      }

      final postWidget = Post(
        isDeletePostVisible: isDeletePostVisible,
        postId: postId,
        onDeletePressed: () async {
          await _fireStore.collection('postWithComments').doc(postId).delete();
        },
        userName: username,
        postContent: postContent,
      );
      posts.add(postWidget);
      posts.add(const Divider(
        height: 9,
        thickness: 8,
        color: Colors.grey,
      ));
    }
    return Expanded(
        child: ListView(
      children: posts,
    ));
  }
}

class MockPostsFunctionality extends Posts {
  @override
  Future addPost(User loggedInUser, String post) async {
    await _fireStore.collection('postWithComments').add({
      'poster': loggedInUser.email,
      'post': post,
    });
    throw UnimplementedError();
  }

  @override
  Widget showPosts(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, User? loggedInUser) {
    if (!snapshot.hasData) {
      return const Center(
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
      bool isDeletePostVisible = false;
      if (username == loggedInUser!.email) {
        isDeletePostVisible = true;
      }

      final postWidget = Post(
        isDeletePostVisible: isDeletePostVisible,
        postId: postId,
        onDeletePressed: () async {
          await _fireStore.collection('postWithComments').doc(postId).delete();
        },
        userName: username,
        postContent: postContent,
      );
      posts.add(postWidget);
      posts.add(const Divider(
        height: 9,
        thickness: 8,
        color: Colors.grey,
      ));
    }
    return Expanded(
        child: ListView(
      children: posts,
    ));
  }
}
