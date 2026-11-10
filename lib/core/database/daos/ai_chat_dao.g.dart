// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_dao.dart';

// ignore_for_file: type=lint
mixin _$AiChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $AiConversationsTable get aiConversations => attachedDatabase.aiConversations;
  $AiMessagesTable get aiMessages => attachedDatabase.aiMessages;
  AiChatDaoManager get managers => AiChatDaoManager(this);
}

class AiChatDaoManager {
  final _$AiChatDaoMixin _db;
  AiChatDaoManager(this._db);
  $$AiConversationsTableTableManager get aiConversations =>
      $$AiConversationsTableTableManager(
        _db.attachedDatabase,
        _db.aiConversations,
      );
  $$AiMessagesTableTableManager get aiMessages =>
      $$AiMessagesTableTableManager(_db.attachedDatabase, _db.aiMessages);
}
