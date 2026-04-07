import 'package:flutter/material.dart';

class AppCircleLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  const AppCircleLoader({
    super.key,
    this.size = 28,
    this.strokeWidth = 2,
    this.color = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xFFEEEEEE),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: backgroundColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
