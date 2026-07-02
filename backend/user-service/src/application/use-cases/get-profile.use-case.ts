import { Injectable, NotFoundException, Inject } from '@nestjs/common';
import { IUserProfileRepository } from '../../domain/repositories/user-profile.repository.interface';

@Injectable()
export class GetProfileUseCase {
  constructor(
    @Inject('IUserProfileRepository')
    private readonly userRepository: IUserProfileRepository,
  ) {}

  async execute(userId: string) {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }
}
