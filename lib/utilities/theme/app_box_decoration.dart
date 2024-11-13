import 'package:flutter/material.dart';
import 'package:ipodaily/utilities/theme/app_colors.dart';
import 'package:ipodaily/utilities/theme/core_box_shadow.dart';
import 'package:ipodaily/utilities/theme/smooth_rectangular_border.dart';

class AppBoxDecoration {
  static BoxDecoration getBoxDecoration({
    double borderRadius = 10,
    Color color = Colors.white,
    double spreadRadius = 0,
    double blurRadius = 20,
    bool showShadow = true,
    BoxBorder? border,
  }) {
    return BoxDecoration(
      borderRadius: SmoothBorderRadius(
        cornerRadius: borderRadius,
        cornerSmoothing: 1.0,
      ),
      border: border,
      color: color,
      boxShadow: showShadow == true
          ? AppBoxShadow.legacyShadow
          // ? [
          //     BoxShadow(
          //       spreadRadius: spreadRadius,
          //       blurRadius: blurRadius,
          //       color: Colors.black.withOpacity(0.06),
          //       offset: const Offset(0, 4),
          //     ),
          //   ]
          : [],
    );
  }
  static BoxDecoration getBorderBoxDecoration({
    double borderRadius = 16,
    Color color = Colors.white,
    double borderWidth = 1,
    Color borderColor = AppColors.frenchGrey,
    double spreadRadius = 0,
    double blurRadius = 12,
    bool showShadow = true,
    Color shadowColor = AppColors.black04,
    double offsetX = 0,
    double offsetY = 4,
  }) {
    return BoxDecoration(
      borderRadius: SmoothBorderRadius(
        cornerRadius: borderRadius,
        cornerSmoothing: 1.0,
      ),
      color: color,
      border: Border.all(
        width: borderWidth,
        color: borderColor,
      ),
      boxShadow: [
        if (showShadow)
          BoxShadow(
            spreadRadius: spreadRadius,
            blurRadius: blurRadius,
            color: shadowColor,
            offset: Offset(offsetX, offsetY),
          ),
      ],
    );
  }
}
