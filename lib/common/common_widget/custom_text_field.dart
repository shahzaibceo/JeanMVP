import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final double? sizedBoxHeight;
  final int? minLines, maxLines, maxLength;
  final Color? fillColor;
  final FormFieldValidator? validator;
  final bool enableSuggestions, autocorrect, readOnly;
  final bool? isDense;
  final Widget? suffixIcon, prefixIcon;
  final String? labelText, hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final EdgeInsets? contentPadding;
  final OutlineInputBorder? enableBorder, focusedBorder;
  final FormFieldSetter<String>? onSaved;
  final TextInputType? keyboardType;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double? borderRadiusValue;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final EdgeInsets? prefixIconPadding, suffixIconPadding;

  const CustomTextFormField({
    super.key,
    this.onTap,
    this.hintStyle,
    this.style,
    this.maxLength,
    required this.readOnly,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.focusedBorder,
    this.keyboardType,
    this.borderRadius,
    this.onSaved,
    this.controller,
    this.contentPadding,
    this.enableBorder,
    this.maxLines,
    this.minLines,
    this.isDense,
    this.fillColor,
    this.validator,
    this.sizedBoxHeight,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    required this.enableSuggestions,
    required this.autocorrect,
    this.showBorder = true,
    this.borderRadiusValue,
    this.prefixIconPadding,
    this.suffixIconPadding,
    this.inputFormatters,
    this.textAlign,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    // Use ThemeCubit to get colors
    final themeCubit = context.watch<ThemeCubit>();

    return TextFormField(
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
      },
       
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      readOnly: readOnly,
      onTap: onTap,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.top,
      onChanged: onChanged,
      onSaved: onSaved,
      cursorColor: themeCubit.textPrimaryColor,
      controller: controller,
      validator: validator,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      style: style ??
          Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: themeCubit.textPrimaryColor,
              ),
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: resp.wp(12),
              vertical: resp.hp(12),
            ),
        isDense: isDense ?? true,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: suffixIconPadding ?? EdgeInsets.zero,
                child: suffixIcon,
              )
            : null,
        fillColor: fillColor ?? themeCubit.containerColor,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: prefixIconPadding ?? EdgeInsets.zero,
                child: prefixIcon,
              )
            : null,
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle ??
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeCubit.unselectedColor,
                  fontWeight: FontWeight.w500,
                ),
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: themeCubit.textPrimaryColor,
            ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: enableBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(resp.radius(borderRadiusValue ?? 8)),
              borderSide: showBorder
                  ? BorderSide(
                      color: themeCubit.textPrimaryColor,
                      width: 1.0,
                    )
                  : BorderSide.none,
            ),
        prefixIconConstraints: BoxConstraints(
          minWidth: resp.wp(24),
          minHeight: resp.hp(24),
        ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(resp.radius(borderRadiusValue ?? 8)),
              borderSide: showBorder
                  ? BorderSide(
                      color: themeCubit.textPrimaryColor,
                      width: 1.0,
                    )
                  : BorderSide.none,
            ),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(resp.radius(borderRadiusValue ?? 8)),
          borderSide: showBorder
              ? BorderSide(
                  color: themeCubit.textPrimaryColor,
                  width: 1.0,
                )
              : BorderSide.none,
        ),
      ),
      inputFormatters: inputFormatters,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: keyboardType,
      onFieldSubmitted: (String value) {
        if (onSubmitted != null) {
          onSubmitted!(value);
        }
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }
}