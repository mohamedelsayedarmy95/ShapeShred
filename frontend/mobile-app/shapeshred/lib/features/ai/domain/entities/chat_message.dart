import 'package:equatable/equatable.dart';

enum ChatRole { user, coach }

class ChatMessage extends Equatable {
  final String content;
  final ChatRole role;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.role,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [content, role, timestamp];
}
