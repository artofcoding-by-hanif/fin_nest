import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ai_chat_tables.dart';

part 'ai_chat_dao.g.dart';

/// Local storage for AI chat history
@DriftAccessor(tables: [AiConversations, AiMessages])
class AiChatDao extends DatabaseAccessor<AppDatabase> with _$AiChatDaoMixin {
  AiChatDao(super.db);

  /// Conversations, most recently active first
  Stream<List<AiConversationEntity>> watchConversations() {
    return (select(aiConversations)..orderBy([
          (c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<AiMessageEntity>> watchMessages(int conversationId) {
    return (select(aiMessages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm(expression: m.id)]))
        .watch();
  }

  Future<List<AiMessageEntity>> getMessages(int conversationId) {
    return (select(aiMessages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm(expression: m.id)]))
        .get();
  }

  Future<int> createConversation(String title) {
    final trimmed = title.trim();
    return into(aiConversations).insert(
      AiConversationsCompanion.insert(
        title: trimmed.length > 120 ? '${trimmed.substring(0, 117)}…' : trimmed,
      ),
    );
  }

  /// Adds a message and bumps the conversation's activity time
  Future<int> addMessage({
    required int conversationId,
    required bool fromUser,
    required String body,
    bool isError = false,
  }) {
    return transaction(() async {
      final id = await into(aiMessages).insert(
        AiMessagesCompanion.insert(
          conversationId: conversationId,
          fromUser: fromUser,
          body: body,
          isError: Value(isError),
        ),
      );
      await (update(aiConversations)..where((c) => c.id.equals(conversationId)))
          .write(AiConversationsCompanion(updatedAt: Value(DateTime.now())));
      return id;
    });
  }

  Future<void> deleteMessage(int id) =>
      (delete(aiMessages)..where((m) => m.id.equals(id))).go();

  /// Deletes a conversation and (via cascade) its messages
  Future<void> deleteConversation(int id) =>
      (delete(aiConversations)..where((c) => c.id.equals(id))).go();

  Future<void> deleteAll() async {
    await delete(aiMessages).go();
    await delete(aiConversations).go();
  }
}
