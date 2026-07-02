import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AiController } from './presentation/controllers/ai.controller';
import { ChatWithCoachUseCase } from './application/use-cases/chat-with-coach.use-case';
import { OpenAiService } from './infrastructure/external-services/openai/openai.service';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
  ],
  controllers: [AiController],
  providers: [
    ChatWithCoachUseCase,
    {
      provide: 'ILlmService',
      useClass: OpenAiService,
    },
  ],
})
export class AppModule {}
