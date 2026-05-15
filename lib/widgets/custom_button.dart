import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

/// Custom button widget with multiple variants and sizes
enum ButtonVariant { primary, secondary, outline }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.isDisabled = false,
  });

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return isDisabled ? AppColors.mediumGray : AppColors.primary;
      case ButtonVariant.secondary:
        return isDisabled ? AppColors.mediumGray : AppColors.secondary;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.textPrimary;
      case ButtonVariant.secondary:
        return AppColors.white;
      case ButtonVariant.outline:
        return AppColors.primary;
    }
  }

  double _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return 12;
      case ButtonSize.large:
        return 16;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: variant == ButtonVariant.outline
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading || isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getPadding() * 2,
              vertical: _getPadding(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(icon, color: _getTextColor(), size: 20),
                  const SizedBox(width: 8),
                ],
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTextColor(),
                      ),
                    ),
                  )
                else
                  Text(
                    label,
                    style: GoogleFonts.roboto(
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
