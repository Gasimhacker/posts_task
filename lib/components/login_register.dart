import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  final String? route;
  final String title;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final Color? color;
  const LoginRegisterButton(
      {super.key,
      this.route,
      required this.title,
      this.onPressed,
      this.padding,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        onPressed: () {
          if (onPressed == null) {
            Navigator.pushNamed(context, route!);
          } else {
            onPressed!();
          }
        },
        color: color ?? const Color(0xffFCB547),
        child: Text(title),
      ),
    );
  }
}
