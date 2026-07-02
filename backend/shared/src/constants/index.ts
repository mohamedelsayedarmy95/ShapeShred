// Constants used across services

export const FITNESS_LEVELS = {
  BEGINNER: 'beginner',
  INTERMEDIATE: 'intermediate',
  ADVANCED: 'advanced',
} as const;

export const GOALS = {
  WEIGHT_LOSS: 'weight_loss',
  MUSCLE_GAIN: 'muscle_gain',
  STRENGTH: 'strength',
  FLEXIBILITY: 'flexibility',
} as const;

export const EXERCISE_CATEGORIES = {
  STRENGTH: 'strength',
  CARDIO: 'cardio',
  HIIT: 'hiit',
  YOGA: 'yoga',
  FLEXIBILITY: 'flexibility',
} as const;

export const SUBSCRIPTION_TIERS = {
  FREE: 'free',
  PREMIUM_MONTHLY: 'premium_monthly',
  PREMIUM_QUARTERLY: 'premium_quarterly',
  PREMIUM_YEARLY: 'premium_yearly',
} as const;

export const PRICING = {
  PREMIUM_MONTHLY: 19.99,
  PREMIUM_QUARTERLY: 47.99,
  PREMIUM_YEARLY: 143.99,
} as const;

export const USER_ROLES = {
  USER: 'user',
  COACH: 'coach',
  ADMIN: 'admin',
} as const;

export const MESSAGE_TYPES = {
  TEXT: 'text',
  IMAGE: 'image',
  VIDEO: 'video',
  AUDIO: 'audio',
  SYSTEM: 'system',
} as const;
