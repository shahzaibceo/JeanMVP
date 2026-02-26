import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final double? borderRadius;
  final BoxShape shape;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final AlignmentGeometry? alignment;
  final String? imagePath;
  final BoxFit fit;

  const CustomContainer({
    super.key,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.boxShadow,
    this.border,
    this.child,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.imagePath,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment, // ✅ ADD THIS
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius ?? 0)
            : null,
        boxShadow: boxShadow,
        border: border,
        image: imagePath != null
            ? DecorationImage(
                image: AssetImage(imagePath!),
                fit: fit,
              )
            : null,
      ),
      padding: padding,
      child: child,
    );
  }
}
