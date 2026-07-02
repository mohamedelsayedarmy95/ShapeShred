import { UserProfile } from '../entities/user-profile.entity';

export interface IUserProfileRepository {
  findById(id: string): Promise<UserProfile | null>;
  findByEmail(email: string): Promise<UserProfile | null>;
  update(user: UserProfile): Promise<UserProfile>;
}
