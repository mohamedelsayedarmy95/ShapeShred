import { AuthUser } from '../entities/auth-user.entity';

export interface IAuthRepository {
  findByEmail(email: string): Promise<AuthUser | null>;
  findById(id: string): Promise<AuthUser | null>;
  create(user: AuthUser): Promise<AuthUser>;
  update(user: AuthUser): Promise<AuthUser>;
}
