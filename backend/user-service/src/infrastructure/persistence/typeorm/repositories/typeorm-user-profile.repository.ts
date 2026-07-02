import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IUserProfileRepository } from '../../../../domain/repositories/user-profile.repository.interface';
import { UserProfile } from '../../../../domain/entities/user-profile.entity';
import { UserOrmEntity } from '../entities/user.orm-entity';

@Injectable()
export class TypeOrmUserProfileRepository implements IUserProfileRepository {
  constructor(
    @InjectRepository(UserOrmEntity)
    private readonly repository: Repository<UserOrmEntity>,
  ) {}

  async findById(id: string): Promise<UserProfile | null> {
    const ormUser = await this.repository.findOne({ where: { id } });
    return ormUser ? this.toDomain(ormUser) : null;
  }

  async findByEmail(email: string): Promise<UserProfile | null> {
    const ormUser = await this.repository.findOne({ where: { email } });
    return ormUser ? this.toDomain(ormUser) : null;
  }

  async update(user: UserProfile): Promise<UserProfile> {
    const ormUser = await this.repository.preload({
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      heightCm: user.heightCm,
      weightKg: user.weightKg,
      fitnessLevel: user.fitnessLevel,
      goal: user.goal,
      profileImageUrl: user.profileImageUrl,
      isActive: user.isActive,
    });

    if (!ormUser) throw new Error('User not found');

    const savedUser = await this.repository.save(ormUser);
    return this.toDomain(savedUser);
  }

  private toDomain(ormUser: UserOrmEntity): UserProfile {
    return new UserProfile({
      id: ormUser.id,
      email: ormUser.email,
      firstName: ormUser.firstName,
      lastName: ormUser.lastName,
      dateOfBirth: ormUser.dateOfBirth,
      gender: ormUser.gender,
      heightCm: Number(ormUser.heightCm),
      weightKg: Number(ormUser.weightKg),
      fitnessLevel: ormUser.fitnessLevel,
      goal: ormUser.goal,
      isPremium: ormUser.isPremium,
      profileImageUrl: ormUser.profileImageUrl,
      isActive: ormUser.isActive,
      createdAt: ormUser.createdAt,
      updatedAt: ormUser.updatedAt,
    });
  }
}
