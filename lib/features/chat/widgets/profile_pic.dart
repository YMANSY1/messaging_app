import 'package:flutter/material.dart';

import '../../core/user.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.user,
    required this.radius,
    required this.fontSize,
  });

  final User user;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.purple,
      child: Text(
        user.username?[0].toUpperCase() ?? "N",
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
