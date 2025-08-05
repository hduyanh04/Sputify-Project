import 'package:flutter/material.dart';
import 'package:sputify/core/config/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double ? height;
  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    super.key
  }); 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      child: Text(
        title
      )
    );
  }
}