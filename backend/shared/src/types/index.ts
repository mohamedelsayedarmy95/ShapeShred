// Common types used across services

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  dateOfBirth?: Date;
  gender?: 'male' | 'female' | 'other';
  heightCm?: number;
  weightKg?: number;
  fitnessLevel?: 'beginner' | 'intermediate' | 'advanced';
  goal?: 'weight_loss' | 'muscle_gain' | 'strength' | 'flexibility';
  isPremium: boolean;
  subscriptionTier?: 'free' | 'premium_monthly' | 'premium_quarterly' | 'premium_yearly';
  subscriptionExpiresAt?: Date;
  profileImageUrl?: string;
  preferences?: Record<string, any>;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserMeasurement {
  id: string;
  userId: string;
  date: Date;
  weightKg?: number;
  bodyFatPercentage?: number;
  chestCm?: number;
  waistCm?: number;
  hipsCm?: number;
  bicepsCm?: number;
  thighsCm?: number;
  progressPhotoUrl?: string;
  moodRating?: number;
  energyLevel?: number;
  stressLevel?: number;
  sleepQuality?: number;
  notes?: string;
  createdAt: Date;
}

export interface Exercise {
  id: string;
  name: string;
  description?: string;
  category: 'strength' | 'cardio' | 'hiit' | 'yoga' | 'flexibility';
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  equipmentRequired: 'none' | 'dumbbells' | 'barbell' | 'gym';
  targetMuscles: string[];
  videoUrl?: string;
  thumbnailUrl?: string;
  instructions: string[];
  formTips: string[];
  caloriesPerMinute?: number;
  isPremium: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface WorkoutPlan {
  id: string;
  userId: string;
  name: string;
  description?: string;
  durationWeeks?: number;
  workoutsPerWeek?: number;
  difficulty?: string;
  goal?: string;
  isActive: boolean;
  createdBy: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface WorkoutSession {
  id: string;
  userId: string;
  workoutPlanId?: string;
  scheduledDate?: Date;
  startedAt?: Date;
  completedAt?: Date;
  durationMinutes?: number;
  caloriesBurned?: number;
  exercisesCompleted?: number;
  totalExercises?: number;
  repCount?: number;
  formScore?: number;
  moodAfterRating?: number;
  notes?: string;
  createdAt: Date;
}

export interface NutritionPlan {
  id: string;
  userId: string;
  name: string;
  dailyCalories?: number;
  dailyProteinG?: number;
  dailyCarbsG?: number;
  dailyFatG?: number;
  dailyFiberG?: number;
  dietaryRestrictions?: string[];
  allergies?: string[];
  budgetLevel?: 'low' | 'medium' | 'high';
  cookingTime?: 'quick' | 'moderate' | 'extensive';
  isActive: boolean;
  createdBy: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Coach {
  id: string;
  userId: string;
  certification?: string;
  yearsExperience?: number;
  specialties?: string[];
  bio?: string;
  hourlyRate?: number;
  maxClients?: number;
  currentClients?: number;
  rating?: number;
  totalReviews?: number;
  availability?: Record<string, any>;
  isVerified: boolean;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface DailyReport {
  id: string;
  userId: string;
  coachId?: string;
  reportDate: Date;
  sleepHours?: number;
  sleepQuality?: number;
  restingHeartRate?: number;
  avgHeartRate?: number;
  maxHeartRate?: number;
  workoutCompleted?: boolean;
  workoutDurationMinutes?: number;
  workoutIntensity?: string;
  caloriesConsumed?: number;
  proteinConsumedG?: number;
  carbsConsumedG?: number;
  fatConsumedG?: number;
  waterConsumedMl?: number;
  moodRating?: number;
  energyLevel?: number;
  stressLevel?: number;
  motivationLevel?: number;
  aiInsights?: Record<string, any>;
  coachNotes?: string;
  coachRecommendations?: Record<string, any>;
  createdAt: Date;
}

export interface Message {
  id: string;
  conversationId: string;
  senderId: string;
  receiverId: string;
  messageType: 'text' | 'image' | 'video' | 'audio' | 'system';
  content?: string;
  mediaUrl?: string;
  isRead: boolean;
  readAt?: Date;
  createdAt: Date;
}

export interface PersonalRecord {
  id: string;
  userId: string;
  exerciseId: string;
  recordType: 'weight' | 'reps' | 'time' | 'distance';
  value: number;
  unit: string;
  achievedAt: Date;
  notes?: string;
}
