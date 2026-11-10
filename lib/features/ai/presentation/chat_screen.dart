import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/widgets/glass/glass.dart';
import '../data/ai_service.dart';
import '../../subscription/presentation/paywall_screen.dart';
import 'ai_consent_sheet.dart';
import 'controllers/chat_controller.dart';
import 'widgets/report_ai_content_sheet.dart';

/// "Ask FinNest": chat with the AI about your own finances
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.initialPrompt});

  /// Sent automatically once consent is confirmed (e.g. "Ask about this")
  final String? initialPrompt;

  /// Opens the chat after checking consent
  static Future<void> open(
    BuildContext context,
    WidgetRef ref, {
    String? initialPrompt,
  }) async {
    if (!await ensureAiConsent(context, ref)) return;
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(initialPrompt: initialPrompt),
      ),
    );
  }

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _focus = FocusNode();

  static const _starters = [
    'Where did my money go this month?',
    'How can I save ₹5,000 more a month?',
    'Am I on track with my budgets?',
    'Which bills or subscriptions could I cut?',
  ];

  @override
  void initState() {
    super.initState();
    final prompt = widget.initialPrompt;
    if (prompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _send(prompt));
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _input.clear();
    await ref.read(chatControllerProvider.notifier).send(text);
  }

  void _showHistory() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HistorySheet(
        onOpen: (id) {
          ref.read(chatControllerProvider.notifier).open(id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(chatControllerProvider);
    final id = state.conversationId;
    final messages = id == null
        ? const <AiMessageEntity>[]
        : ref.watch(chatMessagesProvider(id)).value ?? const [];

    return GlassScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const GlassIcon(
              Icons.auto_awesome_rounded,
              color: AppColors.violet,
              size: 32,
              glow: false,
            ),
            const SizedBox(width: 10),
            Text('Ask FinNest', style: theme.textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Past chats',
            icon: const Icon(Icons.history_rounded),
            onPressed: _showHistory,
          ),
          IconButton(
            tooltip: 'New chat',
            icon: const Icon(Icons.add_comment_rounded),
            onPressed: state.sending
                ? null
                : () => ref.read(chatControllerProvider.notifier).newChat(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty && !state.sending
                  ? _EmptyChat(starters: _starters, onTap: _send)
                  : _MessageList(
                      messages: messages,
                      sending: state.sending,
                      lastError: state.lastError,
                    ),
            ),
            _Footer(state: state),
            _InputBar(
              controller: _input,
              focusNode: _focus,
              enabled: !state.sending,
              onSend: () => _send(_input.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.starters, required this.onTap});

  final List<String> starters;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      children: [
        const Center(
          child: GlassIcon(
            Icons.auto_awesome_rounded,
            color: AppColors.violet,
            size: 84,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Ask about your money',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'FinNest AI answers from your own income, spending, budgets, bills and savings.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        for (final s in starters)
          GlassTile(
            onTap: () => onTap(s),
            leading: const GlassIcon(
              Icons.bolt_rounded,
              color: AppColors.cyan,
              size: 34,
              glow: false,
            ),
            title: Text(s, maxLines: 2),
            trailing: Icon(
              Icons.north_east_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _MessageList extends ConsumerWidget {
  const _MessageList({
    required this.messages,
    required this.sending,
    required this.lastError,
  });

  final List<AiMessageEntity> messages;
  final bool sending;
  final AiException? lastError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reversed so the newest message sits at the bottom, above the input
    final items = messages.reversed.toList();
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: items.length + (sending ? 1 : 0),
      itemBuilder: (context, i) {
        if (sending && i == 0) return const _TypingBubble();
        final m = items[sending ? i - 1 : i];
        final isLatest = m.id == messages.last.id;
        if (m.fromUser) return _UserBubble(text: m.body);
        if (m.isError) {
          return _ErrorBubble(
            message: m,
            canRetry: isLatest && !sending,
            wantsUpgrade: isLatest && (lastError?.wantsUpgrade ?? false),
          );
        }
        return _AiBubble(message: m);
      },
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 48, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(6),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.violet.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SelectableText(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.message});

  final AiMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final style = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      strong: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      listBullet: theme.textTheme.bodyMedium,
      h1: theme.textTheme.titleMedium,
      h2: theme.textTheme.titleMedium,
      h3: theme.textTheme.titleSmall,
      tableBorder: TableBorder.all(color: context.glass.border),
      blockSpacing: 10,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              blur: false,
              radius: 20,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: MarkdownBody(
                data: message.body,
                styleSheet: style,
                selectable: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 2),
              child: Row(
                children: [
                  Text(
                    DateFormat('h:mm a').format(message.createdAt),
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Copy',
                    iconSize: 16,
                    color: muted,
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: message.body),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied')));
                      }
                    },
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Report this answer',
                    iconSize: 16,
                    color: muted,
                    icon: const Icon(Icons.flag_outlined),
                    onPressed: () => showReportAiContentSheet(
                      context,
                      kind: 'chat',
                      content: message.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBubble extends ConsumerWidget {
  const _ErrorBubble({
    required this.message,
    required this.canRetry,
    required this.wantsUpgrade,
  });

  final AiMessageEntity message;
  final bool canRetry;
  final bool wantsUpgrade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = wantsUpgrade ? AppColors.warning : context.glass.expense;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 14),
        child: GlassCard(
          blur: false,
          tint: color,
          radius: 20,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    wantsUpgrade
                        ? Icons.workspace_premium_rounded
                        : Icons.error_outline_rounded,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message.body,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (wantsUpgrade)
                    TextButton(
                      onPressed: () => showPaywall(
                        context,
                        reason:
                            ref
                                    .read(chatControllerProvider)
                                    .lastError
                                    ?.reason ==
                                AiFailure.premiumRequired
                            ? PaywallReason.premiumFeature
                            : PaywallReason.aiLimit,
                      ),
                      child: const Text('See Premium'),
                    )
                  else if (canRetry)
                    TextButton.icon(
                      onPressed: () => ref
                          .read(chatControllerProvider.notifier)
                          .retry(message.id),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try again'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three pulsing dots while the assistant is thinking
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: GlassCard(
          blur: false,
          radius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Opacity(
                    opacity:
                        0.35 +
                        0.65 * (1 - ((_c.value * 3 - i) % 3).clamp(0, 1)),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = state.remaining;
    final quota = remaining == null
        ? null
        : state.premium
        ? '$remaining messages left today'
        : '$remaining free ${remaining == 1 ? 'message' : 'messages'} left today';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 6),
      child: Text(
        [?quota, 'AI can make mistakes. Not financial advice.'].join('  ·  '),
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: GlassCard(
        radius: 28,
        padding: const EdgeInsets.fromLTRB(18, 4, 6, 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 5,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => enabled ? onSend() : null,
                decoration: const InputDecoration(
                  hintText: 'Ask about your spending…',
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 6),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final canSend = enabled && value.text.trim().isNotEmpty;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: canSend ? 1 : 0.4,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: canSend ? onSend : null,
                      customBorder: const CircleBorder(),
                      child: Ink(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySheet extends ConsumerWidget {
  const _HistorySheet({required this.onOpen});

  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final conversations =
        ref.watch(chatConversationsProvider).value ?? const [];
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text('Past chats', style: theme.textTheme.titleLarge),
            ),
            if (conversations.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Text(
                  'No saved chats yet.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: conversations.length,
                  itemBuilder: (context, i) {
                    final c = conversations[i];
                    return Dismissible(
                      key: ValueKey(c.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          gradient: AppColors.expenseGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) async {
                        final controller = ref.read(
                          chatControllerProvider.notifier,
                        );
                        if (ref.read(chatControllerProvider).conversationId ==
                            c.id) {
                          controller.newChat();
                        }
                        await GetIt.instance<AppDatabase>().aiChatDao
                            .deleteConversation(c.id);
                      },
                      child: GlassTile(
                        onTap: () => onOpen(c.id),
                        leading: const GlassIcon(
                          Icons.chat_bubble_rounded,
                          color: AppColors.violet,
                          size: 36,
                          glow: false,
                        ),
                        title: Text(c.title),
                        subtitle: Text(
                          DateFormat('d MMM, h:mm a').format(c.updatedAt),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
