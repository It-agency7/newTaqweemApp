import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'color_manager.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorManager.baseColor,
      highlightColor: ColorManager.highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorManager.primary.withOpacity(0.20),
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}
