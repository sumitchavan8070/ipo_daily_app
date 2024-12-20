import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipodaily/utilities/theme/app_colors.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText({super.key, required this.subtitle, this.textStyle});
  final String? subtitle;
  final TextStyle? textStyle;

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.subtitle == null
                ? "-"
                : showMore == true
                    ? widget.subtitle
                    : ('${widget.subtitle?.split('').take(80).join('')}...'),
            style: widget.textStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  showMore = !showMore;
                });
              },
            text: showMore ? "Read Less" : "Read More",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  decorationColor: AppColors.primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
