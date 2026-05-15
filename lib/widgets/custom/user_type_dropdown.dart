import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/user_model.dart';

/// Custom dropdown for user type selection
class UserTypeDropdown extends StatelessWidget {
  final UserRole? value;
  final ValueChanged<UserRole?>? onChanged;
  final String? label;
  final String? hint;
  final String? Function(UserRole?)? validator;

  const UserTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.validator,
  });

  String _getUserTypeDisplayName(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'Customer';
      case UserRole.admin:
        return 'Admin';
      case UserRole.driver:
        return 'Delivery Man';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<UserRole>(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint ?? 'Select user type',
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          items: UserRole.values.map((role) {
            return DropdownMenuItem<UserRole>(
              value: role,
              child: Row(
                children: [
                  Icon(
                    _getUserTypeIcon(role),
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(_getUserTypeDisplayName(role)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getUserTypeIcon(UserRole role) {
    switch (role) {
      case UserRole.user:
        return Icons.person;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.driver:
        return Icons.delivery_dining;
    }
  }
}
