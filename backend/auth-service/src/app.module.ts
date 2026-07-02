import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { UserOrmEntity } from './infrastructure/persistence/typeorm/entities/user.orm-entity';
import { RefreshTokenOrmEntity } from './infrastructure/persistence/typeorm/entities/refresh-token.orm-entity';
import { AuthController } from './presentation/controllers/auth.controller';
import { RegisterUseCase } from './application/use-cases/register.use-case';
import { LoginUseCase } from './application/use-cases/login.use-case';
import { TypeOrmAuthRepository } from './infrastructure/persistence/typeorm/repositories/typeorm-auth.repository';
import { JwtStrategy } from './infrastructure/auth/strategies/jwt.strategy';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET', 'secret'),
        signOptions: { expiresIn: '15m' },
      }),
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
        entities: [UserOrmEntity, RefreshTokenOrmEntity],
        synchronize: false,
      }),
    }),
    TypeOrmModule.forFeature([UserOrmEntity, RefreshTokenOrmEntity]),
  ],
  controllers: [AuthController],
  providers: [
    RegisterUseCase,
    LoginUseCase,
    JwtStrategy,
    {
      provide: 'IAuthRepository',
      useClass: TypeOrmAuthRepository,
    },
  ],
})
export class AppModule {}
