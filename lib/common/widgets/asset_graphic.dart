import 'package:flutter/material.dart';

class AssetGraphic extends StatelessWidget {
  final String path;
  final Color? color;
  final double opacity;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Alignment? alignment;

  const AssetGraphic({
    required this.path,
    super.key,
    this.color,
    this.opacity = 1.0,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: opacity, child: Image.asset(path, height: height, width: width, fit: fit, color: color));
  }
}
