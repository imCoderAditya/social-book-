import 'package:flutter/material.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';

class CircleImageView extends StatelessWidget {
  final String? image;
  final String? displayName;
  final double? radius;

  const CircleImageView({
    super.key,
    this.image,
    this.displayName,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final double r =
        radius ?? MediaQuery.of(context).size.width * 0.06;

    return CircleAvatar(
      radius: r,
      backgroundColor: AppColors.primaryColor,
      child: ClipOval(
        child: Image.network(
          image ?? "",
          width: r * 2,
          height: r * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _fallbackText(r);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: r * 0.6,
              height: r * 0.6,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _fallbackText(double r) {
    final String letter =
        (displayName != null && displayName!.trim().isNotEmpty)
            ? displayName!.trim()[0].toUpperCase()
            : "";

    return Center(
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: r * 0.9,
        ),
      ),
    );
  }
}
