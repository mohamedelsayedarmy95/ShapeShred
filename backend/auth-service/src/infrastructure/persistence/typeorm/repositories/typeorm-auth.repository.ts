import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IAuthRepository } from '../../../../domain/repositories/auth.repository.interface';
import { AuthUser } from '../../../../domain/entities/auth-user.entity';
import { UserOrmEntity } from '../entities/user.orm-entity';

@Injectable()
export class TypeOrmAuthRepository implements IAuthRepository {
  constructor(
    @InjectRepository(UserOrmEntity)
    private readonly repository: Repository<UserOrmEntity>,
  ) {}

  async findByEmail(email: string): Promise<AuthUser | null> {
    const ormUser = await this.repository.findOne({ where: { email } });
    return ormUser ? this.toDomain(ormUser) : null;
  }

  async findById(id: string): Promise<AuthUser | null> {
    const ormUser = await this.repository.findOne({ where: { id } });
    return ormUser ? this.toDomain(ormUser) : null;
  }

  async create(user: AuthUser): Promise<AuthUser> {
    const ormUser = this.repository.create({
      email: user.email,
      passwordHash: user.passwordHash,
      firstName: user.firstName,
      lastName: user.lastName,
      isActive: user.isActive,
    });
    const savedUser = await this.repository.save(ormUser);
    return this.toDomain(savedUser);
  }

  async update(user: AuthUser): Promise<AuthUser> {
    await this.repository.update(user.id, {
      firstName: user.firstName,
      lastName: user.lastName,
      isActive: user.isActive,
    });
    return user;
  }

  private toDomain(ormUser: UserOrmEntity): AuthUser {
    return new AuthUser({
      id: ormUser.id,
      email: ormUser.email,
      passwordHash: ormUser.passwordHash,
      firstName: ormUser.firstName,
      lastName: ormUser.lastName,
      isActive: ormUser.isActive,
    });
  }
}
