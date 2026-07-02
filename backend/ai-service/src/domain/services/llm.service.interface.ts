import { AiMessage } from '../entities/ai-message.entity';

export interface ILlmService {
  generateResponse(messages: AiMessage[]): Promise<string>;
  streamResponse(messages: AiMessage[]): AsyncIterable<string>;
}
