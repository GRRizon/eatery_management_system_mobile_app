import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

/// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final Widget? icon;
  final bool isOutlined;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48,
    this.icon,
    this.isOutlined = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final button = isOutlined
        ? OutlinedButton(
            onPressed: isEnabled && !isLoading ? onPressed : null,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(width ?? double.infinity, height),
              padding: padding,
              disabledForegroundColor: AppColors.textLight,
            ),
            child: _buildButtonContent(),
          )
        : ElevatedButton(
            onPressed: isEnabled && !isLoading ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
              minimumSize: Size(width ?? double.infinity, height),
              padding: padding,
              disabledBackgroundColor: AppColors.mediumGray,
              disabledForegroundColor: AppColors.textLight,
            ),
            child: _buildButtonContent(),
          );

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primary : AppColors.textOnPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon!, const SizedBox(width: 8), Text(label)],
      );
    }

    return Text(label);
  }
}
