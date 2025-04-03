import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/color_extensions.dart';
import '../../core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final Color? highlightColor;
  final double? width;
  final double? height;
  final String text;
  final double horizontalPadding;
  final bool compact;
  final TextStyle? style;

  const AppButton.primary({
    required this.onPressed,
    required this.text,
    this.color = AppColors.primaryColor,
    this.highlightColor = AppColors.primaryColorDark,
    this.width = 96,
    this.height = 24,
    this.horizontalPadding = 16.0,
    this.compact = false,
    this.style,
    super.key,
  });

  const AppButton.secondary({
    required this.onPressed,

    required this.text,
    this.color = AppColors.secondaryButtonColor,
    this.highlightColor = AppColors.secondaryButtonHighlightColor,
    this.width,
    this.height,
    this.horizontalPadding = 16.0,
    this.compact = false,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: MaterialButton(
        elevation: 0,
        height: 40,
        highlightElevation: 0,
        textColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        highlightColor: highlightColor ?? AppColors.primaryColorDark,
        color: color ?? AppColors.primaryColor,
        onPressed:
            onPressed == null
                ? null
                : () {
                  onPressed?.call();
                },
        child: SizedBox(
          width: compact ? null : double.maxFinite,
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            duration: const Duration(milliseconds: 200),
            child: Text(
              text,
              style:
                  style?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: style?.color?.safeWithOpacity(onPressed != null ? 1 : 0.4),
                  ) ??
                  const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
