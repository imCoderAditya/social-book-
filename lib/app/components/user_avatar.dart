import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color backgroundColor;
  final IconData fallbackIcon;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 18,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.fallbackIcon = Icons.person,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: _hasImage ? NetworkImage(imageUrl!) : null,
      child: !_hasImage
          ? Icon(
              fallbackIcon,
              size: radius + 2,
              color: Colors.grey.shade600,
            )
          : null,
    );
  }
}
