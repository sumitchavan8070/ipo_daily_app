import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ipodaily/utilities/constants/assets_path.dart';
import 'package:ipodaily/utilities/theme/app_box_decoration.dart';
import 'package:ipodaily/utilities/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? height;
  final double? width;
  final String title;
  final String subTitle;
  final bool? isBackButton;

  const CustomAppBar({
    Key? key,
    this.height,
    this.width,
    required this.title,
    required this.subTitle,
    this.isBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 127,
      width: width ?? MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: AppBoxDecoration.getBoxDecoration(
        showShadow: false,
        color: AppColors.ghostWhite,
      ),
      child: Row(
        children: [
          _buildIsBackButton(
            isBackButton ?? true,
            () {
              context.pop();
            },
          ),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
            children: [
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.darkJungleGreen, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildIsBackButton(bool isBackButton, Function() onTap) {
    if (isBackButton == true) {
      return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(AssetPath.backSvg, height: 50, width: 50),
      );
    }
    // return SvgPicture.asset(AssetPath.titleIcon, height: 50, width: 50);
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 127);
}
