import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: Text(
            title,
            style: AppTextStyles.heading,
          ),
        ),

        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text("View All"),
          ),
      ],
    );
  }
}