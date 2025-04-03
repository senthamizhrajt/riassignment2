import 'package:flutter/cupertino.dart';

class SafePadding extends StatelessWidget {
  final double extraHeight;

  const SafePadding({this.extraHeight = 0.0, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.bottom + extraHeight,
    );
  }
}
