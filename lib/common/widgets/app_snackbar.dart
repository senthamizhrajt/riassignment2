import 'package:flutter/material.dart';

class AppSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _currentSnackBar;

  static void show(BuildContext context, String message, {Color? backgroundColor, SnackBarAction? action}) {
    if (_currentSnackBar != null) {
      try {
        _currentSnackBar!.close();
      } catch (e) {
        // Ignore error if snackbar was already dismissed
      }
      _currentSnackBar = null;
    }
    _currentSnackBar = ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 3), action: action));
  }

  static void showOverlaySnackbar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    final OverlayEntry overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom, // Controls how high the Snackbar appears
            child: FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1), // Starts off-screen (bottom)
                  end: const Offset(0, 0), // Ends at the intended position
                ).animate(animation),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(color: Color(0xFF2C2C2C)),
                    child: Text(message, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      await animationController.reverse();
      overlayEntry.remove();
    });
  }
}
