import 'package:flutter/material.dart';

class CustomIconBtn extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final Widget icon;

  CustomIconBtn(
      {required this.color, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    // Use Material + InkWell so the full colored area is tappable and shows ripple.
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
      ),
    );
  }
}
