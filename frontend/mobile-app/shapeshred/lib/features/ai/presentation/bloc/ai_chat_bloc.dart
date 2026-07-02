import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/use_cases/send_message_use_case.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

@injectable
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final SendMessageUseCase _sendMessageUseCase;

  AiChatBloc(this._sendMessageUseCase) : super(const AiChatState()) {
    on<MessageSent>((event, emit) async {
      final userMessage = ChatMessage(
        content: event.message,
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );

      final currentHistory = List<ChatMessage>.from(state.messages);
      final historyWithUser = List<ChatMessage>.from(currentHistory)
        ..add(userMessage);

      emit(state.copyWith(messages: historyWithUser, isLoading: true));

      final result = await _sendMessageUseCase(
        SendMessageParams(message: event.message, history: currentHistory),
      );

      result.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (coachMessage) {
          final finalHistory = List<ChatMessage>.from(historyWithUser)
            ..add(coachMessage);
          emit(state.copyWith(messages: finalHistory, isLoading: false));
        },
      );
    });
  }
}
