import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/comment_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  int numberOfComments = 0;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              AnonymousAvatar(
                backgroundColor: kThemeColor,
                radius: 20,
                iconColor: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.userName!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: widget.isDeletePostVisible,
                child: IconButton(
                    onPressed: widget.onDeletePressed,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.postContent!,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  final Stream<QuerySnapshot> commentsStream =
                      _fireStore.collectionGroup(widget.postId).snapshots();
                  setState(() {}); //to update the number of comments
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: commentsStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final commentsDocs = snapshot.data?.docs;
                                numberOfComments = commentsDocs!.length;
                                List<Comment> commentsList = [];
                                for (var commentDoc in commentsDocs) {
                                  final Map commentMap =
                                      commentDoc.data() as Map;
                                  final commentContent = commentMap['comment'];
                                  final commenter = commentMap['commenter'];
                                  final commentId = commentDoc.id;

                                  bool isDeleteCommentVisible = false;
                                  if (commenter == loggedInUser!.email) {
                                    isDeleteCommentVisible = true;
                                  }
                                  final commentWidget = Comment(
                                    isDeleteCommentVisible:
                                        isDeleteCommentVisible,
                                    comment: commentContent,
                                    commenter: commenter,
                                    onDeleteCommentPressed: () {
                                      _fireStore
                                          .collection('postWithComments')
                                          .doc(widget.postId)
                                          .collection(widget.postId)
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
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                      });
                },
                child: Text(
                  '$numberOfComments comments',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            ],
          ),
          Divider(
            thickness: 2,
          ),
          TextField(
            controller: commentController,
            onChanged: (value) {
              comment = value;
            },
            decoration: InputDecoration(
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
                  icon: Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }
}
