import 'package:flutter/material.dart';

import 'glass/glass.dart';

/// Empty state: a large glass icon, a message and an optional action.
class EmptyState extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Color? color;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassIcon(
              icon ?? Icons.inbox_rounded,
              color: color ?? AppColors.violet,
              size: 88,
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
