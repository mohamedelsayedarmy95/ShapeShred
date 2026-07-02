import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NutritionPlanOrmEntity } from './infrastructure/persistence/typeorm/entities/nutrition-plan.orm-entity';
import { MealOrmEntity } from './infrastructure/persistence/typeorm/entities/meal.orm-entity';
import { NutritionController } from './presentation/controllers/nutrition.controller';
import { GetActiveNutritionPlanUseCase } from './application/use-cases/get-active-nutrition-plan.use-case';
import { TypeOrmNutritionRepository } from './infrastructure/persistence/typeorm/repositories/typeorm-nutrition.repository';

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
        entities: [NutritionPlanOrmEntity, MealOrmEntity],
        synchronize: false,
      }),
    }),
    TypeOrmModule.forFeature([NutritionPlanOrmEntity, MealOrmEntity]),
  ],
  controllers: [NutritionController],
  providers: [
    GetActiveNutritionPlanUseCase,
    {
      provide: 'INutritionRepository',
      useClass: TypeOrmNutritionRepository,
    },
  ],
})
export class AppModule {}
