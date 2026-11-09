import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'glass/gradient_widgets.dart';

/// Primary full-width button, rendered as a glowing [GradientButton].
///
/// `backgroundColor` (if given) turns into a gradient based on that color,
/// so existing call sites like "save expense in red" keep their meaning.
class StyledElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const StyledElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: text,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      gradient: backgroundColor == null
          ? AppColors.accentGradient
          : AppColors.tintGradient(backgroundColor!),
    );
  }
}

/// Secondary full-width button on glass.
class StyledOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? borderColor;
  final Color? foregroundColor;

  const StyledOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.borderColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      foregroundColor: foregroundColor,
      side: borderColor == null
          ? null
          : BorderSide(color: borderColor!, width: 1.2),
    );

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? OutlinedButton(onPressed: onPressed, style: style, child: Text(text))
          : OutlinedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: 20),
              label: Text(text),
            ),
    );
  }
}
