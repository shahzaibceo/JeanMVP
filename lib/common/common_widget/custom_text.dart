import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final bool overflow;
  final TextAlign? textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.textAlign,
    this.overflow = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
      maxLines: overflow ? maxLines ?? 1 : null,
    );
  }
}
