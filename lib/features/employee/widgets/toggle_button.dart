import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ToggleButton extends StatefulWidget {
  final double? width;
  final double? height;
  final String text;
  final double horizontalPadding;
  final bool compact;
  final TextStyle? style;
  final bool isSelected;
  final Function(bool value)? onChanged;

  const ToggleButton({
    required this.text,
    this.width = 96,
    this.height = 24,
    this.horizontalPadding = 16.0,
    this.compact = false,
    this.style,
    this.isSelected = false,
    this.onChanged,
    super.key,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: MaterialButton(
        elevation: 0,
        height: 40,
        highlightElevation: 0,
        textColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        highlightColor: !widget.isSelected ? AppColors.secondaryButtonHighlightColor : AppColors.primaryColorDark,
        color: !widget.isSelected ? AppColors.secondaryButtonColor : AppColors.primaryColor,
        onPressed: () {
          setState(() {
            widget.onChanged?.call(widget.isSelected);
          });
        },

        child: SizedBox(
          width: widget.compact ? null : double.maxFinite,
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.text,
              style: TextStyle(fontWeight: FontWeight.w500, color: widget.isSelected ? Colors.white : AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
