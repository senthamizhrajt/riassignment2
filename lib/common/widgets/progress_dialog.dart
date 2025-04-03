import 'package:flutter/material.dart';

class ProgressDialog {
  static bool _isShowing = false;

  static void show(BuildContext context, {Widget? child}) {
    if (_isShowing) {
      return;
    }

    _isShowing = true;
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: SizedBox(height: 32.0, width: 32.0, child: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context).pop(true);
    }
  }
}
