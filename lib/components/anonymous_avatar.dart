import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';

class AnonymousAvatar extends StatelessWidget {
  double? radius;
  Color? backgroundColor;
  Color? iconColor;

  AnonymousAvatar({this.radius, this.backgroundColor, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CircleAvatar(
        radius: radius ?? KCircleAvatarRadius,
        backgroundColor: backgroundColor ?? Colors.white,
        child: Icon(
          size: radius ?? KCircleAvatarRadius,
          Icons.person,
          color: iconColor ?? KThemeColor,
        ),
      ),
    );
  }
}
