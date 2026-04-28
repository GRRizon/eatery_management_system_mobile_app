import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

/// Custom App Bar Widget for Eatery App
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.showBackButton = false,
    this.leading,
    this.elevation = 2,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      centerTitle: true,
      elevation: elevation,
      backgroundColor: backgroundColor ?? AppColors.primary,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textOnPrimary,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      actions: actions,
    );
  }
}
