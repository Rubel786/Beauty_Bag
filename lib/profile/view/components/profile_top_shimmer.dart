import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/constants.dart';

class ProfileTopShimmer extends StatelessWidget {
  const ProfileTopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kPrimaryShadowColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(radius: 32, backgroundColor: Colors.white),
            const SizedBox(height: 10),
            Container(height: 12, width: 100, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 12, width: 80, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
