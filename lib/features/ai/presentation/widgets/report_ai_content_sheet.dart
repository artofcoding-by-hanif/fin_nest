import 'package:flutter/material.dart';

import '../../../../core/widgets/glass/glass.dart';
import '../../data/ai_service.dart';

/// Lets the user flag AI output as harmful, offensive or wrong, as Google
/// Play's AI-generated content policy requires.
Future<void> showReportAiContentSheet(
  BuildContext context, {
  required String kind,
  required String content,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReportSheet(kind: kind, content: content),
  );
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.kind, required this.content});

  final String kind;
  final String content;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  static const _reasons = {
    'inaccurate': 'Wrong or misleading',
    'harmful': 'Harmful or risky advice',
    'offensive': 'Offensive or inappropriate',
    'other': 'Something else',
  };

  String? _reason;
  final _note = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AiService.instance.report(
        kind: widget.kind,
        reason: reason,
        content: widget.content,
        note: _note.text,
      );
      if (mounted) Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Thanks. The report was sent.')),
      );
    } on AiException catch (e) {
      if (mounted) setState(() => _sending = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Report this answer', style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                'The answer text and your note are sent to FinNest for review. '
                'Your financial data is not included.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              GlassChips(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in _reasons.entries)
                      ChoiceChip(
                        label: Text(e.value),
                        selected: _reason == e.key,
                        onSelected: (_) => setState(() => _reason = e.key),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _note,
                maxLength: 500,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Details (optional)'),
              ),
              const SizedBox(height: 12),
              GradientButton(
                label: 'Send report',
                icon: Icons.flag_rounded,
                isLoading: _sending,
                gradient: AppColors.expenseGradient,
                onPressed: _reason == null ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
