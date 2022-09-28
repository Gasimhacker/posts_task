import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';
import 'package:posts_task/components/anonymous_avatar.dart';
import 'package:posts_task/components/comment_ui.dart';
import 'package:posts_task/services/models.dart';

class Post extends StatelessWidget {
  final commentController = TextEditingController();
  final String? postContent;
  final String? userName;
  final Function()? onDeletePressed;
  final Future Function(String, TextEditingController) addCommentFunctionality;
  final Future<List<Comments>> loadComments;
  final Function(Comments)? onDeleteCommentPressed;
  String comment = '';
  Post(
      {this.postContent,
      this.userName,
      this.onDeletePressed,
      required this.addCommentFunctionality,
      required this.loadComments,
      required this.onDeleteCommentPressed});

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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => FutureBuilder<List<Comments>>(
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Comment(
                              comment: snapshot.data![index].comment,
                              commenter: snapshot.data![index].commenter,
                              onDeleteCommentPressed: () {
                                onDeleteCommentPressed!(snapshot.data![index]);
                              },
                            );
                          },
                          itemCount:
                              snapshot.hasData ? snapshot.data!.length : 0,
                        );
                      },
                      future: loadComments,
                    ),
                  );
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
