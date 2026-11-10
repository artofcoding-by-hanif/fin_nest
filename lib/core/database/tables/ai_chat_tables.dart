import 'package:drift/drift.dart';

/// A saved conversation with the AI assistant. Chats stay on the device;
/// only the messages of the current request are sent to the server.
@DataClassName('AiConversationEntity')
class AiConversations extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Short title, taken from the first question
  TextColumn get title => text().withLength(max: 120)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// One message in a conversation
@DataClassName('AiMessageEntity')
class AiMessages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get conversationId => integer().references(
    AiConversations,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// True for the user's messages, false for the assistant's
  BoolColumn get fromUser => boolean()();

  TextColumn get body => text()();

  /// A failed request shown in the chat; never sent back as history
  BoolColumn get isError => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
