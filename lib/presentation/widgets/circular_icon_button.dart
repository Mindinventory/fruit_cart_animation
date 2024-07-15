import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color decorationColor;
  final BoxBorder? border;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const CircularIconButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.decorationColor,
    this.border,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: padding,
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border,
            boxShadow: kElevationToShadow[2],
            color: decorationColor,
            shape: BoxShape.circle,
          ),
          child: child),
    );
  }
}
