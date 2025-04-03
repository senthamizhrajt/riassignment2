import 'dart:ui';

extension ColorExtensions on Color {
  Color safeWithOpacity(double opacity) {
    return withAlpha((opacity * 255).toInt());
  }
}