import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String commenter;
  final String comment;
  final Function() onDeleteCommentPressed;
  final bool isDeleteCommentVisible;
  const Comment(
      {super.key,
      required this.commenter,
      required this.comment,
      required this.onDeleteCommentPressed,
      required this.isDeleteCommentVisible});
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
            trailing: Visibility(
              visible: isDeleteCommentVisible,
              child: IconButton(
                onPressed: onDeleteCommentPressed,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
