import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import { ILlmService } from '../../../domain/services/llm.service.interface';
import { AiMessage } from '../../../domain/entities/ai-message.entity';

@Injectable()
export class OpenAiService implements ILlmService {
  private openai: OpenAI;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  async generateResponse(messages: AiMessage[]): Promise<string> {
    try {
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-4-turbo-preview',
        messages: messages.map((m) => ({
          role: m.role as any,
          content: m.content,
        })),
      });

      return completion.choices[0].message.content || 'I apologize, I could not generate a response.';
    } catch (error) {
      console.error('OpenAI Error:', error);
      throw new InternalServerErrorException('Failed to generate AI response');
    }
  }

  async *streamResponse(messages: AiMessage[]): AsyncIterable<string> {
    const stream = await this.openai.chat.completions.create({
      model: 'gpt-4-turbo-preview',
      messages: messages.map((m) => ({
        role: m.role as any,
        content: m.content,
      })),
      stream: true,
    });

    for await (const chunk of stream) {
      yield chunk.choices[0]?.delta?.content || '';
    }
  }
}
