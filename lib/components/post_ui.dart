import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:posts_task/pages/comments_bottom_sheet.dart';

final _fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class Post extends StatefulWidget {
  final String? postContent;
  final String? userName;
  final Function()? onDeletePressed;
  final String postId;
  final bool isDeletePostVisible;
  Post(
      {this.postContent,
      this.userName,
      this.onDeletePressed,
      required this.postId,
      required this.isDeletePostVisible});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final commentController = TextEditingController();

  String comment = '';

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    if (_auth.currentUser != null) {
      loggedInUser = _auth.currentUser;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              const AnonymousAvatar(
                backgroundColor: kThemeColor,
                radius: 20,
                iconColor: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.userName!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: widget.isDeletePostVisible,
                child: IconButton(
                    onPressed: widget.onDeletePressed,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.postContent!,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: _fireStore.collectionGroup(widget.postId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final numComments = snapshot.data!.size;
                    return GestureDetector(
                      onTap: _showCommentsBottomSheet,
                      child: Text(
                        '$numComments comments',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  } else {
                    // if there's no data
                    return Text(
                      'no comments yet',
                      style: TextStyle(color: Colors.grey[600]),
                    );
                  }
                },
              )
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          TextField(
            controller: commentController,
            onChanged: (value) {
              comment = value;
            },
            decoration: const InputDecoration(
              hintText: 'Write a comment...',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    commentController.clear();
                    await _fireStore
                        .collection('postWithComments')
                        .doc(widget.postId)
                        .collection(widget.postId)
                        .add({
                      'comment': comment,
                      'commenter': loggedInUser?.email,
                    });
                  },
                  icon: const Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }

  _showCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CommentsBottomSheet(postId: widget.postId);
      },
    );
  }
}
