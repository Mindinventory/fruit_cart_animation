import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool enable;
  final double? height;
  final double? width;
  final double? fontSize;

  // final FontWeight? fontWeight;
  final Color? background;
  final Color? borderColor;
  final Widget? child;
  final EdgeInsets? padding;
  final bool placeholder;
  final Alignment? alignment;

  const OutlinedButtonWidget({
    super.key,
    this.placeholder = false,
    this.text,
    this.child,
    this.padding,
    this.onTap,
    this.textColor,
    this.enable = true,
    this.height,
    this.width,
    this.fontSize,
    this.alignment = Alignment.center,
    this.background,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border:
                  placeholder ? null : Border.all(color: !enable ? Colors.grey.shade400 : (borderColor ?? Colors.grey)),
              color: background,
            ),
            alignment: alignment,
            child: placeholder
                ? const Offstage()
                : (child != null
                    ? DefaultTextStyle(
                        style: TextStyle(
                                fontSize: 16,
                                color: !enable ? Colors.grey : (textColor ?? Colors.black),
                                fontWeight: FontWeight.w500)
                            .copyWith(height: 0.8),
                        child: child!,
                      )
                    : Text(
                        text!,
                        style: TextStyle(
                                fontSize: 16,
                                color: !enable ? Colors.grey : (textColor ?? Colors.black),
                                fontWeight: FontWeight.w500)
                            .copyWith(height: 0.8),
                      ))));
  }
}
