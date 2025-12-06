import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.maxWidth = false,
    this.isLoading = false,
    this.padding,
    this.color,
    this.side,
    this.borderRadius,
    this.loadingIndicatorColor,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? loadingIndicatorColor;
  final bool maxWidth;
  final bool isLoading;
  final TextStyle? textStyle;
  final BorderSide? side;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color ?? AppColors.primary(context),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      minWidth: maxWidth ? double.infinity : null,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadiusGeometry.circular(16.r),
        side: side ?? BorderSide.none,
      ),
      padding:
          padding ??
          EdgeInsetsGeometry.symmetric(horizontal: 24.w, vertical: 13.h),
      onPressed: onPressed,
      child: isLoading
          ? CupertinoActivityIndicator(
              color: loadingIndicatorColor ?? AppColors.background(context),
            )
          : Text(text, style: textStyle),
    );
  }
}
