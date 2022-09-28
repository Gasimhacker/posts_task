import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String commenter;
  final String comment;
  final Function() onDeleteCommentPressed;
  Comment(
      {required this.commenter,
      required this.comment,
      required this.onDeleteCommentPressed});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commenter),
                Text(comment),
              ],
            ),
            trailing: IconButton(
                onPressed: onDeleteCommentPressed,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ),
          Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
