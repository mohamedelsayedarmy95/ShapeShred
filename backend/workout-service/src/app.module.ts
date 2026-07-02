import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ExerciseOrmEntity } from './infrastructure/persistence/typeorm/entities/exercise.orm-entity';
import { ExerciseController } from './presentation/controllers/exercise.controller';
import { GetAllExercisesUseCase } from './application/use-cases/get-all-exercises.use-case';
import { TypeOrmExerciseRepository } from './infrastructure/persistence/typeorm/repositories/typeorm-exercise.repository';

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
        entities: [ExerciseOrmEntity],
        synchronize: false,
      }),
    }),
    TypeOrmModule.forFeature([ExerciseOrmEntity]),
  ],
  controllers: [ExerciseController],
  providers: [
    GetAllExercisesUseCase,
    {
      provide: 'IExerciseRepository',
      useClass: TypeOrmExerciseRepository,
    },
  ],
})
export class AppModule {}
