import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color decorationColor;

  const CircularIconButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[2],
              color: decorationColor,
              shape: BoxShape.circle),
          child: child),
    );
  }
}
