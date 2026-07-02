import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shapeshred/core/theme/app_tokens.dart';

class AppSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const AppSkeleton({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
      ),
    );
  }
}
