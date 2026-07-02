import { IsString, IsOptional, IsDateString, IsNumber, Min, Max } from 'class-validator';

export class UpdateProfileDto {
  @IsString()
  @IsOptional()
  firstName?: string;

  @IsString()
  @IsOptional()
  lastName?: string;

  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @IsString()
  @IsOptional()
  gender?: string;

  @IsNumber()
  @IsOptional()
  @Min(50)
  @Max(250)
  heightCm?: number;

  @IsNumber()
  @IsOptional()
  @Min(20)
  @Max(300)
  weightKg?: number;

  @IsString()
  @IsOptional()
  fitnessLevel?: string;

  @IsString()
  @IsOptional()
  goal?: string;
}
