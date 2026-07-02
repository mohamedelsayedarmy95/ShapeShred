import { Injectable, Inject } from '@nestjs/common';
import { ILlmService } from '../../domain/services/llm.service.interface';
import { AiMessage, MessageRole } from '../../domain/entities/ai-message.entity';

@Injectable()
export class ChatWithCoachUseCase {
  constructor(
    @Inject('ILlmService')
    private readonly llmService: ILlmService,
  ) {}

  async execute(userId: string, userMessage: string, history: AiMessage[] = []) {
    const systemPrompt = new AiMessage({
      userId,
      role: MessageRole.SYSTEM,
      content: `You are the ShapeShred AI Coach. You are professional, motivating, and disciplined.
      Your advice is scientifically grounded. You follow the ShapeShred monochromatic luxury brand identity in your "voice".
      Keep responses concise and actionable.`,
    });

    const messages = [systemPrompt, ...history, new AiMessage({ userId, role: MessageRole.USER, content: userMessage })];

    const coachResponse = await this.llmService.generateResponse(messages);

    return {
      role: MessageRole.COACH,
      content: coachResponse,
      timestamp: new Date(),
    };
  }
}
