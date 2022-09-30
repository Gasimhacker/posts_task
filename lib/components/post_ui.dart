import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/comment_ui.dart';

final _fireStore = FirebaseFirestore.instance;

class Post extends StatelessWidget {
  final String? postContent;
  final String? userName;
  final Function()? onDeletePressed;
  final Future Function(String, TextEditingController) addCommentFunctionality;
  final String postId;
  Post({
    this.postContent,
    this.userName,
    this.onDeletePressed,
    required this.addCommentFunctionality,
    required this.postId,
  });

  final commentController = TextEditingController();

  String comment = '';

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
                userName!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postContent!,
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
                      _fireStore.collectionGroup(postId).snapshots();

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: commentsStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final commentsDocs = snapshot.data?.docs;

                                for (var commentDoc in commentsDocs!) {
                                  final Map commentMap =
                                      commentDoc.data() as Map;
                                  final commentContent = commentMap['comment'];
                                  final commenter = commentMap['commenter'];
                                  return ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Comment(
                                        comment: commentContent,
                                        commenter: commenter,
                                        onDeleteCommentPressed: () {
                                          commentsDocs.remove(commentDoc);
                                        },
                                      );
                                    },
                                    itemCount: commentsDocs.length,
                                  );
                                }
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                      });
                },
                child: Text(
                  'comments',
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
                  onPressed: () {
                    addCommentFunctionality(comment, commentController);
                  },
                  icon: Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }
}
