-- ShapeShred Database Schema
-- PostgreSQL 14+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  gender VARCHAR(20),
  height_cm DECIMAL(5,2),
  weight_kg DECIMAL(5,2),
  fitness_level VARCHAR(20),
  goal VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_premium BOOLEAN DEFAULT FALSE,
  subscription_tier VARCHAR(20),
  subscription_expires_at TIMESTAMP,
  profile_image_url VARCHAR(500),
  preferences JSONB,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription_tier ON users(subscription_tier);

-- User measurements table
CREATE TABLE user_measurements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  weight_kg DECIMAL(5,2),
  body_fat_percentage DECIMAL(5,2),
  chest_cm DECIMAL(5,2),
  waist_cm DECIMAL(5,2),
  hips_cm DECIMAL(5,2),
  biceps_cm DECIMAL(5,2),
  thighs_cm DECIMAL(5,2),
  progress_photo_url VARCHAR(500),
  mood_rating INTEGER CHECK (mood_rating BETWEEN 1 AND 10),
  energy_level INTEGER CHECK (energy_level BETWEEN 1 AND 10),
  stress_level INTEGER CHECK (stress_level BETWEEN 1 AND 10),
  sleep_quality INTEGER CHECK (sleep_quality BETWEEN 1 AND 10),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_measurements_user_id ON user_measurements(user_id);
CREATE INDEX idx_user_measurements_date ON user_measurements(date);

-- Exercises table
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  difficulty VARCHAR(20),
  equipment_required VARCHAR(100),
  target_muscles VARCHAR(100)[],
  video_url VARCHAR(500),
  thumbnail_url VARCHAR(500),
  instructions TEXT[],
  form_tips TEXT[],
  calories_per_minute DECIMAL(5,2),
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_exercises_category ON exercises(category);
CREATE INDEX idx_exercises_difficulty ON exercises(difficulty);
CREATE INDEX idx_exercises_is_premium ON exercises(is_premium);

-- Workout plans table
CREATE TABLE workout_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  duration_weeks INTEGER,
  workouts_per_week INTEGER,
  difficulty VARCHAR(20),
  goal VARCHAR(50),
  is_active BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workout_plans_user_id ON workout_plans(user_id);
CREATE INDEX idx_workout_plans_is_active ON workout_plans(is_active);

-- Workout sessions table
CREATE TABLE workout_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  workout_plan_id UUID REFERENCES workout_plans(id),
  scheduled_date DATE,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  duration_minutes INTEGER,
  calories_burned INTEGER,
  exercises_completed INTEGER,
  total_exercises INTEGER,
  rep_count INTEGER,
  form_score DECIMAL(5,2),
  mood_after_rating INTEGER CHECK (mood_after_rating BETWEEN 1 AND 10),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workout_sessions_user_id ON workout_sessions(user_id);
CREATE INDEX idx_workout_sessions_workout_plan_id ON workout_sessions(workout_plan_id);
CREATE INDEX idx_workout_sessions_scheduled_date ON workout_sessions(scheduled_date);

-- Workout exercises table
CREATE TABLE workout_exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_session_id UUID REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  sets INTEGER,
  reps INTEGER,
  weight_kg DECIMAL(5,2),
  duration_seconds INTEGER,
  rest_seconds INTEGER,
  completed_sets INTEGER,
  completed_reps INTEGER,
  form_issues_detected INTEGER[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workout_exercises_workout_session_id ON workout_exercises(workout_session_id);
CREATE INDEX idx_workout_exercises_exercise_id ON workout_exercises(exercise_id);

-- Nutrition plans table
CREATE TABLE nutrition_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  daily_calories INTEGER,
  daily_protein_g INTEGER,
  daily_carbs_g INTEGER,
  daily_fat_g INTEGER,
  daily_fiber_g INTEGER,
  dietary_restrictions VARCHAR(100)[],
  allergies VARCHAR(100)[],
  budget_level VARCHAR(20),
  cooking_time VARCHAR(20),
  is_active BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_nutrition_plans_user_id ON nutrition_plans(user_id);
CREATE INDEX idx_nutrition_plans_is_active ON nutrition_plans(is_active);

-- Meals table
CREATE TABLE meals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nutrition_plan_id UUID REFERENCES nutrition_plans(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  meal_type VARCHAR(20),
  calories INTEGER,
  protein_g INTEGER,
  carbs_g INTEGER,
  fat_g INTEGER,
  fiber_g INTEGER,
  instructions TEXT[],
  ingredients JSONB,
  prep_time_minutes INTEGER,
  photo_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_meals_nutrition_plan_id ON meals(nutrition_plan_id);
CREATE INDEX idx_meals_meal_type ON meals(meal_type);

-- Food logs table
CREATE TABLE food_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  meal_id UUID REFERENCES meals(id),
  date DATE NOT NULL,
  meal_type VARCHAR(20),
  food_name VARCHAR(255),
  calories INTEGER,
  protein_g INTEGER,
  carbs_g INTEGER,
  fat_g INTEGER,
  fiber_g INTEGER,
  serving_size VARCHAR(50),
  barcode VARCHAR(100),
  logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_food_logs_user_id ON food_logs(user_id);
CREATE INDEX idx_food_logs_date ON food_logs(date);
CREATE INDEX idx_food_logs_barcode ON food_logs(barcode);

-- Coaches table
CREATE TABLE coaches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  certification VARCHAR(255),
  years_experience INTEGER,
  specialties VARCHAR(100)[],
  bio TEXT,
  hourly_rate DECIMAL(10,2),
  max_clients INTEGER,
  current_clients INTEGER DEFAULT 0,
  rating DECIMAL(3,2),
  total_reviews INTEGER,
  availability JSONB,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_coaches_user_id ON coaches(user_id);
CREATE INDEX idx_coaches_is_verified ON coaches(is_verified);
CREATE INDEX idx_coaches_is_active ON coaches(is_active);

-- Coach assignments table
CREATE TABLE coach_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  coach_id UUID REFERENCES coaches(id) ON DELETE CASCADE,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ended_at TIMESTAMP,
  status VARCHAR(20),
  notes TEXT,
  UNIQUE(user_id, coach_id, status)
);

CREATE INDEX idx_coach_assignments_user_id ON coach_assignments(user_id);
CREATE INDEX idx_coach_assignments_coach_id ON coach_assignments(coach_id);
CREATE INDEX idx_coach_assignments_status ON coach_assignments(status);

-- Daily reports table
CREATE TABLE daily_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  coach_id UUID REFERENCES coaches(id),
  report_date DATE NOT NULL,
  sleep_hours DECIMAL(4,2),
  sleep_quality INTEGER,
  resting_heart_rate INTEGER,
  avg_heart_rate INTEGER,
  max_heart_rate INTEGER,
  workout_completed BOOLEAN,
  workout_duration_minutes INTEGER,
  workout_intensity VARCHAR(20),
  calories_consumed INTEGER,
  protein_consumed_g INTEGER,
  carbs_consumed_g INTEGER,
  fat_consumed_g INTEGER,
  water_consumed_ml INTEGER,
  mood_rating INTEGER,
  energy_level INTEGER,
  stress_level INTEGER,
  motivation_level INTEGER,
  ai_insights JSONB,
  coach_notes TEXT,
  coach_recommendations JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_daily_reports_user_id ON daily_reports(user_id);
CREATE INDEX idx_daily_reports_coach_id ON daily_reports(coach_id);
CREATE INDEX idx_daily_reports_report_date ON daily_reports(report_date);

-- Messages table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
  message_type VARCHAR(20),
  content TEXT,
  media_url VARCHAR(500),
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);

-- Supplement schedules table
CREATE TABLE supplement_schedules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  supplement_name VARCHAR(255) NOT NULL,
  dosage VARCHAR(100),
  frequency VARCHAR(50),
  scheduled_times TIME[],
  current_stock INTEGER,
  low_stock_threshold INTEGER,
  reminder_enabled BOOLEAN DEFAULT TRUE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_supplement_schedules_user_id ON supplement_schedules(user_id);

-- Personal records table
CREATE TABLE personal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  record_type VARCHAR(20),
  value DECIMAL(10,2),
  unit VARCHAR(20),
  achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  notes TEXT
);

CREATE INDEX idx_personal_records_user_id ON personal_records(user_id);
CREATE INDEX idx_personal_records_exercise_id ON personal_records(exercise_id);
CREATE INDEX idx_personal_records_record_type ON personal_records(record_type);

-- Refresh tokens table
CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(500) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_revoked BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- Subscriptions table
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  stripe_subscription_id VARCHAR(255),
  stripe_customer_id VARCHAR(255),
  tier VARCHAR(20) NOT NULL,
  status VARCHAR(20),
  current_period_start TIMESTAMP,
  current_period_end TIMESTAMP,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_stripe_subscription_id ON subscriptions(stripe_subscription_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

-- Notifications table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

-- Audit log table
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100),
  entity_id UUID,
  changes JSONB,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
