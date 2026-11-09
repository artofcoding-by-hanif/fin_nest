import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Frosted glass text field. Borders, fill and label styles come from
/// the app's `inputDecorationTheme`.
class StyledTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool filled;
  final Color? fillColor;

  const StyledTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.filled = true,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmount = keyboardType != null &&
        keyboardType!.index == TextInputType.number.index &&
        prefixText != null;

    return TextFormField(
      controller: controller,
      style: isAmount
          ? AppTypography.amount(20).copyWith(color: theme.colorScheme.onSurface)
          : theme.textTheme.bodyLarge,
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        prefixStyle: isAmount
            ? AppTypography.amount(20).copyWith(color: theme.colorScheme.primary)
            : theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}

/// Glass "picker" field that opens a selector when tapped.
class StyledSelectorField extends StatelessWidget {
  final String? labelText;
  final String displayText;
  final IconData? icon;
  final VoidCallback onTap;
  final bool hasValue;

  const StyledSelectorField({
    super.key,
    this.labelText,
    required this.displayText,
    this.icon,
    required this.onTap,
    this.hasValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: hasValue
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Icon(
              icon ?? Icons.expand_more_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
