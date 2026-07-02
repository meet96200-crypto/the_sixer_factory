import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}