part of 'ai_chat_bloc.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class MessageSent extends AiChatEvent {
  final String message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}
