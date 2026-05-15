import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

/// Custom card widget with consistent styling
class CustomCard extends StatefulWidget {
  final Widget child;
  final double elevation;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool clickable;
  final Color? backgroundColor;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.elevation = 4,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.onTap,
    this.clickable = false,
    this.backgroundColor,
    this.border,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = widget.clickable),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.white,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border:
                widget.border ??
                Border.all(color: AppColors.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(
                  alpha: _isHovered ? 0.15 : 0.08,
                ),
                blurRadius: _isHovered ? 12 : widget.elevation.toDouble(),
                offset: _isHovered ? const Offset(0, 6) : const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}

/// Custom dialog widget
class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsets contentPadding;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.contentPadding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          Padding(padding: contentPadding, child: content),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading dialog with spinner
class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              if (message != null)
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Success message snackbar
void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.roboto(fontSize: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.success,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Error message snackbar
void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: AppColors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.roboto(fontSize: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
