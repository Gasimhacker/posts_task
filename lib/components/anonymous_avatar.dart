import 'package:flutter/material.dart';
import 'package:posts_task/constants.dart';

class AnonymousAvatar extends StatelessWidget {
  final double? radius;
  final Color? backgroundColor;
  final Color? iconColor;

  const AnonymousAvatar(
      {super.key, this.radius, this.backgroundColor, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CircleAvatar(
        radius: radius ?? kCircleAvatarRadius,
        backgroundColor: backgroundColor ?? Colors.white,
        child: Icon(
          size: radius ?? kCircleAvatarRadius,
          Icons.person,
          color: iconColor ?? kThemeColor,
        ),
      ),
    );
  }
}
