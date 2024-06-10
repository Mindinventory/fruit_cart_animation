import 'package:flutter/material.dart';

class FilledButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color fillColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final bool enable;
  final double? height;
  final double? width;
  final double? fontSize;
  final EdgeInsets? padding;
  final bool placeholder;

  const FilledButtonWidget(
      {super.key,
      required this.text,
      this.onTap,
      this.placeholder = false,
      this.fontWeight,
      this.fillColor = const Color(0xff70CB8D),
      this.enable = true,
      this.textColor,
      this.height,
      this.width,
      this.fontSize,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: placeholder
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            )
          : ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(padding ?? EdgeInsets.zero),
                enableFeedback: enable,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                elevation: !enable ? const WidgetStatePropertyAll(0) : null,
                backgroundColor: WidgetStateProperty.all(fillColor),
              ),
              onPressed: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                          fontSize: 16,
                          color: !enable
                              ? Colors.grey
                              : (textColor ?? Colors.black),
                          fontWeight: FontWeight.w500)
                      .copyWith(height: 0.8),
                ),
              ),
            ),
    );
  }
}
