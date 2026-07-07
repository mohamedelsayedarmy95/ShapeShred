import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/network/dio_client.dart';
import 'package:shapeshred/core/error/failures.dart';
import 'package:shapeshred/features/ai/domain/entities/chat_message.dart';
import 'package:shapeshred/features/ai/domain/repositories/ai_repository.dart';

@Injectable(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final DioClient _dioClient;

  AiRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(
      String message, List<ChatMessage> history) async {
    try {
      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        'http://localhost:3006/ai/chat',
        data: {
          'message': message,
          'history': history
              .map((m) => {
                    'role': m.role == ChatRole.user ? 'user' : 'assistant',
                    'content': m.content,
                  })
              .toList(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return Right(ChatMessage(
          content: data['content'] as String,
          role: ChatRole.coach,
          timestamp: DateTime.parse(data['timestamp'] as String),
        ));
      }
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
