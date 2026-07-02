import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/ai_repository.dart';

@injectable
class SendMessageUseCase implements UseCase<ChatMessage, SendMessageParams> {
  final AiRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, ChatMessage>> call(SendMessageParams params) {
    return _repository.sendMessage(params.message, params.history);
  }
}

class SendMessageParams {
  final String message;
  final List<ChatMessage> history;

  SendMessageParams({required this.message, required this.history});
}
