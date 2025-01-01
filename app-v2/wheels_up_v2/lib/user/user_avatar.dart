import 'package:flutter/material.dart';
import 'package:wheels_up_v2/user/user_model.dart';
import 'package:wheels_up_v2/user/user_service.dart';

class UserAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key, 
    required this.user, 
    this.radius = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: user?.picture != null 
            ? NetworkImage(UserService.getUserProfilePictureUrl(user!, null).toString()) 
            : null,
        child: user?.picture == null
            ? Icon(Icons.person, size: radius)
            : null,
      ),
    );
  }
}