import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ipodaily/dashboard_module/controller/default_controller.dart';
import 'package:ipodaily/utilities/common/key_value_pair_model.dart';
import 'package:ipodaily/utilities/constants/assets_path.dart';
import 'package:ipodaily/utilities/navigation/go_paths.dart';
import 'package:ipodaily/utilities/navigation/navigator.dart';
import 'package:ipodaily/utilities/theme/app_box_decoration.dart';
import 'package:ipodaily/utilities/theme/app_colors.dart';

final _defaultController = Get.put(DefaultApiController());

class BlurBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int, String) onItemTapped;

  BlurBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BlurBottomNavigationBar> createState() => _BlurBottomNavigationBarState();
}

class _BlurBottomNavigationBarState extends State<BlurBottomNavigationBar> {
  final navBarData = [
    KeyValuePairModel(key: AssetPath.mainBoard, value: GoPaths.mainBoard),
    KeyValuePairModel(key: AssetPath.sme, value: GoPaths.sme),
    KeyValuePairModel(key: AssetPath.buyBack, value: GoPaths.buyBack),
    KeyValuePairModel(key: AssetPath.blogs, value: GoPaths.blogs),
    KeyValuePairModel(key: AssetPath.allotment, value: GoPaths.webView),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildBlurNavBar();
  }

  _buildBlurNavBar() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: AppBoxDecoration.getBorderBoxDecoration(
        showShadow: false,
        color: AppColors.white.withOpacity(0.9),
        borderRadius: 16,
        borderColor: AppColors.gunMetal.withOpacity(0.1),
        borderWidth: 1,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: AppBoxDecoration.getBoxDecoration(
          showShadow: false,
          color: AppColors.white.withOpacity(0.9),
          borderRadius: 16,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50, tileMode: TileMode.mirror),
              child: Container(
                color: Colors.black.withOpacity(0), // Adjust opacity as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(navBarData.length, (index) {
                  final item = navBarData[index];
                  return GestureDetector(
                    onTap: () {
                      widget.onItemTapped(index, item.value);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          item.key,
                          colorFilter: ColorFilter.mode(
                            widget.selectedIndex == index
                                ? AppColors.primaryColor
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.value == GoPaths.webView
                              ? "ALLOTMENT"
                              : item.value.replaceAll("/", "").toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
