import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class ExtendedTextField extends StatefulWidget {
  final double? height;
  final double width;
  final TextStyle? hintStyle;
  final bool isError;
  final String? errorText;
  final String hintText;
  final String counterText;
  final int? maxLines;
  final int minLines;
  final bool isReadOnly;
  final Widget? suffixIcon;
  final TextAlignVertical textAlignVertical;
  final TextStyle? style;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final Function(String newText)? onChanged;
  final BoxConstraints? suffixIconConstraints;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;
  final double? borderRadius;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final TextCapitalization textCapitalization;
  final String defaultText;
  final TextStyle? counterStyle;

  const ExtendedTextField({
    super.key,
    this.height,
    this.width = 320,
    this.controller,
    this.isError = false,
    this.errorText = '',
    this.hintText = '',
    this.counterText = '',
    this.maxLines = 1,
    this.minLines = 1,
    this.isReadOnly = false,
    this.suffixIcon,
    this.textAlignVertical = TextAlignVertical.top,
    this.decoration,
    this.style,
    this.onChanged,
    this.suffixIconConstraints,
    this.autoFocus = false,
    this.textInputAction,
    this.onEditingComplete,
    this.focusNode,
    this.fillColor,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.textAlign = TextAlign.left,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.textCapitalization = TextCapitalization.none,
    this.defaultText = '',
    this.counterStyle,
  });

  @override
  State<StatefulWidget> createState() {
    return _LabelledTextFieldState();
  }
}

class _LabelledTextFieldState extends State<ExtendedTextField> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(minWidth: widget.width),
          height: widget.height,
          child: Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              TextField(
                textCapitalization: widget.textCapitalization,
                focusNode: widget.focusNode,
                controller: widget.controller ?? TextEditingController(text: widget.defaultText),
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                readOnly: widget.isReadOnly,
                style: widget.style,
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                autofocus: widget.autoFocus,
                enabled: widget.enabled,
                onTap: widget.onTap,
                onEditingComplete: widget.onEditingComplete,
                textAlign: widget.textAlign,
                textAlignVertical: widget.textAlignVertical,
                onChanged: widget.onChanged,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                decoration:
                    widget.decoration ??
                    InputDecoration(
                      suffixIcon: widget.suffixIcon,
                      hintStyle: widget.hintStyle ?? Theme.of(context).inputDecorationTheme.hintStyle,
                      contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      isDense: true,
                      counterText: widget.counterText,
                      counterStyle: widget.counterStyle,
                      suffixIconConstraints:
                          widget.suffixIconConstraints ??
                          widget.prefixIconConstraints ??
                          const BoxConstraints(minWidth: 36, maxHeight: 24),
                      prefixIcon: widget.prefixIcon,
                      prefixIconConstraints:
                          widget.prefixIconConstraints ?? const BoxConstraints(minWidth: 36, maxHeight: 24),
                      hintText: widget.hintText,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
                        borderSide: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
                        borderSide: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
                        borderSide: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                      ),
                    ),
              ),
              if (widget.errorText != null && widget.errorText!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(widget.errorText!, style: const TextStyle(height: 1.2, color: Colors.red, fontSize: 12)),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
