import { Controller, Post, Body, Req } from '@nestjs/common';
import { ChatWithCoachUseCase } from '../../application/use-cases/chat-with-coach.use-case';

@Controller('ai')
export class AiController {
  constructor(private readonly chatUseCase: ChatWithCoachUseCase) {}

  @Post('chat')
  async chat(@Req() req: any, @Body() body: { message: string, history?: any[] }) {
    const userId = req.user?.userId || 'test-user';
    return this.chatUseCase.execute(userId, body.message, body.history || []);
  }
}
