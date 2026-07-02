import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserOrmEntity } from './infrastructure/persistence/typeorm/entities/user.orm-entity';
import { UserController } from './presentation/controllers/user.controller';
import { GetProfileUseCase } from './application/use-cases/get-profile.use-case';
import { UpdateProfileUseCase } from './application/use-cases/update-profile.use-case';
import { TypeOrmUserProfileRepository } from './infrastructure/persistence/typeorm/repositories/typeorm-user-profile.repository';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST', 'localhost'),
        port: configService.get<number>('DB_PORT', 5432),
        username: configService.get<string>('DB_USERNAME', 'postgres'),
        password: configService.get<string>('DB_PASSWORD', 'postgres'),
        database: configService.get<string>('DB_NAME', 'shapeshred'),
        entities: [UserOrmEntity],
        synchronize: false,
      }),
    }),
    TypeOrmModule.forFeature([UserOrmEntity]),
  ],
  controllers: [UserController],
  providers: [
    GetProfileUseCase,
    UpdateProfileUseCase,
    {
      provide: 'IUserProfileRepository',
      useClass: TypeOrmUserProfileRepository,
    },
  ],
})
export class AppModule {}
