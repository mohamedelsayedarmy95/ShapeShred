# ShapeShred API Documentation

## Base URL
```
Development: http://localhost:3001/api/v1
Production: https://api.shapeshred.com/api/v1
```

## Authentication
All API endpoints require authentication using JWT tokens, except for public endpoints marked as `@Public()`.

### Headers
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Token Refresh
Access tokens expire after 15 minutes. Use the refresh token to get a new access token.

---

## Authentication Endpoints

### Register
```http
POST /auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe"
    },
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token"
  }
}
```

### Login
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "isPremium": false
    },
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token"
  }
}
```

### Logout
```http
POST /auth/logout
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### Refresh Token
```http
POST /auth/refresh-token
```

**Request Body:**
```json
{
  "refreshToken": "refresh_token"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "accessToken": "new_jwt_token",
    "refreshToken": "new_refresh_token"
  }
}
```

### Enable 2FA
```http
POST /auth/enable-2fa
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "secret": "otp_secret",
    "qrCode": "data:image/png;base64,..."
  }
}
```

### Verify 2FA
```http
POST /auth/verify-2fa
```

**Request Body:**
```json
{
  "token": "123456"
}
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "2FA verified successfully"
}
```

### Forgot Password
```http
POST /auth/forgot-password
```

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Password reset email sent"
}
```

### Reset Password
```http
POST /auth/reset-password
```

**Request Body:**
```json
{
  "token": "reset_token",
  "newPassword": "NewSecurePassword123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

---

## User Endpoints

### Get Current User
```http
GET /users/me
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "dateOfBirth": "1990-01-01",
    "gender": "male",
    "heightCm": 180,
    "weightKg": 75,
    "fitnessLevel": "intermediate",
    "goal": "muscle_gain",
    "isPremium": true,
    "subscriptionTier": "premium_monthly",
    "profileImageUrl": "https://...",
    "preferences": {
      "units": "metric",
      "language": "en"
    }
  }
}
```

### Update Current User
```http
PUT /users/me
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Smith",
  "heightCm": 182,
  "weightKg": 78,
  "fitnessLevel": "advanced",
  "goal": "strength"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "firstName": "John",
    "lastName": "Smith",
    "heightCm": 182,
    "weightKg": 78,
    "fitnessLevel": "advanced",
    "goal": "strength"
  }
}
```

### Get User Preferences
```http
GET /users/me/preferences
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "units": "metric",
    "language": "en",
    "notifications": {
      "workoutReminders": true,
      "mealReminders": true,
      "progressUpdates": true
    }
  }
}
```

### Update User Preferences
```http
PUT /users/me/preferences
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "units": "imperial",
  "language": "es",
  "notifications": {
    "workoutReminders": false,
    "mealReminders": true,
    "progressUpdates": true
  }
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "units": "imperial",
    "language": "es",
    "notifications": {
      "workoutReminders": false,
      "mealReminders": true,
      "progressUpdates": true
    }
  }
}
```

### Get User Measurements
```http
GET /users/me/measurements
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `startDate` (optional): ISO date string
- `endDate` (optional): ISO date string
- `limit` (optional): Number of records (default: 30)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "date": "2024-01-15",
      "weightKg": 75.5,
      "bodyFatPercentage": 15.2,
      "chestCm": 100,
      "waistCm": 80,
      "hipsCm": 95,
      "moodRating": 8,
      "energyLevel": 7,
      "stressLevel": 4
    }
  ]
}
```

### Create User Measurement
```http
POST /users/me/measurements
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "date": "2024-01-15",
  "weightKg": 75.5,
  "bodyFatPercentage": 15.2,
  "chestCm": 100,
  "waistCm": 80,
  "hipsCm": 95,
  "moodRating": 8,
  "energyLevel": 7,
  "stressLevel": 4,
  "notes": "Feeling good today"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "date": "2024-01-15",
    "weightKg": 75.5,
    "bodyFatPercentage": 15.2,
    "chestCm": 100,
    "waistCm": 80,
    "hipsCm": 95,
    "moodRating": 8,
    "energyLevel": 7,
    "stressLevel": 4,
    "notes": "Feeling good today"
  }
}
```

### Get Subscription
```http
GET /users/me/subscription
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "tier": "premium_monthly",
    "status": "active",
    "currentPeriodStart": "2024-01-01T00:00:00Z",
    "currentPeriodEnd": "2024-02-01T00:00:00Z",
    "cancelAtPeriodEnd": false
  }
}
```

### Upgrade Subscription
```http
POST /users/me/subscription/upgrade
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "tier": "premium_monthly",
  "paymentMethodId": "pm_1234567890"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "subscriptionId": "uuid",
    "stripeSubscriptionId": "sub_1234567890",
    "tier": "premium_monthly",
    "status": "active",
    "clientSecret": "pi_1234567890_secret_abc"
  }
}
```

### Cancel Subscription
```http
POST /users/me/subscription/cancel
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Subscription cancelled successfully"
}
```

---

## Workout Endpoints

### Get Exercises
```http
GET /workouts/exercises
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `category` (optional): strength, cardio, hiit, yoga, flexibility
- `difficulty` (optional): beginner, intermediate, advanced
- `equipment` (optional): none, dumbbells, barbell, gym
- `muscle` (optional): chest, back, legs, arms, shoulders, core
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "exercises": [
      {
        "id": "uuid",
        "name": "Push-up",
        "description": "Classic bodyweight exercise",
        "category": "strength",
        "difficulty": "beginner",
        "equipmentRequired": "none",
        "targetMuscles": ["chest", "triceps", "shoulders"],
        "videoUrl": "https://...",
        "thumbnailUrl": "https://...",
        "instructions": [
          "Start in a plank position",
          "Lower your body until chest nearly touches floor",
          "Push back up to starting position"
        ],
        "formTips": [
          "Keep your core tight",
          "Maintain a straight line from head to heels"
        ],
        "caloriesPerMinute": 8.5,
        "isPremium": false
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

### Get Exercise by ID
```http
GET /workouts/exercises/:id
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Push-up",
    "description": "Classic bodyweight exercise",
    "category": "strength",
    "difficulty": "beginner",
    "equipmentRequired": "none",
    "targetMuscles": ["chest", "triceps", "shoulders"],
    "videoUrl": "https://...",
    "thumbnailUrl": "https://...",
    "instructions": [
      "Start in a plank position",
      "Lower your body until chest nearly touches floor",
      "Push back up to starting position"
    ],
    "formTips": [
      "Keep your core tight",
      "Maintain a straight line from head to heels"
    ],
    "caloriesPerMinute": 8.5,
    "isPremium": false
  }
}
```

### Get Workout Plans
```http
GET /workouts/plans
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Beginner Strength Program",
      "description": "12-week program for beginners",
      "durationWeeks": 12,
      "workoutsPerWeek": 3,
      "difficulty": "beginner",
      "goal": "strength",
      "isActive": true,
      "createdBy": "uuid",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### Create Workout Plan
```http
POST /workouts/plans
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "name": "Custom Strength Plan",
  "description": "My custom plan",
  "durationWeeks": 8,
  "workoutsPerWeek": 4,
  "difficulty": "intermediate",
  "goal": "muscle_gain"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Custom Strength Plan",
    "description": "My custom plan",
    "durationWeeks": 8,
    "workoutsPerWeek": 4,
    "difficulty": "intermediate",
    "goal": "muscle_gain",
    "isActive": false,
    "createdBy": "uuid",
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

### Activate Workout Plan
```http
POST /workouts/plans/:id/activate
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Workout plan activated successfully"
}
```

### Get Workout Sessions
```http
GET /workouts/sessions
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `startDate` (optional): ISO date string
- `endDate` (optional): ISO date string
- `status` (optional): completed, in_progress, scheduled

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "workoutPlanId": "uuid",
      "scheduledDate": "2024-01-15",
      "startedAt": "2024-01-15T09:00:00Z",
      "completedAt": "2024-01-15T09:45:00Z",
      "durationMinutes": 45,
      "caloriesBurned": 350,
      "exercisesCompleted": 12,
      "totalExercises": 12,
      "repCount": 150,
      "formScore": 92.5,
      "moodAfterRating": 8
    }
  ]
}
```

### Create Workout Session
```http
POST /workouts/sessions
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "workoutPlanId": "uuid",
  "scheduledDate": "2024-01-15"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "workoutPlanId": "uuid",
    "scheduledDate": "2024-01-15",
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

### Start Workout Session
```http
POST /workouts/sessions/:id/start
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "startedAt": "2024-01-15T09:00:00Z"
  }
}
```

### Complete Workout Session
```http
POST /workouts/sessions/:id/complete
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "durationMinutes": 45,
  "caloriesBurned": 350,
  "exercisesCompleted": 12,
  "repCount": 150,
  "formScore": 92.5,
  "moodAfterRating": 8,
  "notes": "Great workout!"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "completedAt": "2024-01-15T09:45:00Z",
    "durationMinutes": 45,
    "caloriesBurned": 350,
    "exercisesCompleted": 12,
    "repCount": 150,
    "formScore": 92.5,
    "moodAfterRating": 8,
    "notes": "Great workout!"
  }
}
```

### Get Personal Records
```http
GET /workouts/personal-records
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `exerciseId` (optional): Filter by exercise
- `recordType` (optional): weight, reps, time, distance

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "exerciseId": "uuid",
      "exerciseName": "Bench Press",
      "recordType": "weight",
      "value": 100,
      "unit": "kg",
      "achievedAt": "2024-01-15T00:00:00Z"
    }
  ]
}
```

### Create Personal Record
```http
POST /workouts/personal-records
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "exerciseId": "uuid",
  "recordType": "weight",
  "value": 100,
  "unit": "kg",
  "notes": "New PR!"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "exerciseId": "uuid",
    "recordType": "weight",
    "value": 100,
    "unit": "kg",
    "achievedAt": "2024-01-15T00:00:00Z",
    "notes": "New PR!"
  }
}
```

---

## Nutrition Endpoints

### Get Nutrition Plans
```http
GET /nutrition/plans
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Muscle Gain Plan",
      "dailyCalories": 3000,
      "dailyProteinG": 180,
      "dailyCarbsG": 300,
      "dailyFatG": 100,
      "dailyFiberG": 30,
      "dietaryRestrictions": [],
      "allergies": [],
      "budgetLevel": "medium",
      "cookingTime": "moderate",
      "isActive": true,
      "createdBy": "uuid",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### Create Nutrition Plan
```http
POST /nutrition/plans
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "name": "Custom Nutrition Plan",
  "dailyCalories": 2500,
  "dailyProteinG": 150,
  "dailyCarbsG": 250,
  "dailyFatG": 80,
  "dailyFiberG": 25,
  "dietaryRestrictions": ["vegetarian"],
  "allergies": ["nuts"],
  "budgetLevel": "medium",
  "cookingTime": "quick"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Custom Nutrition Plan",
    "dailyCalories": 2500,
    "dailyProteinG": 150,
    "dailyCarbsG": 250,
    "dailyFatG": 80,
    "dailyFiberG": 25,
    "dietaryRestrictions": ["vegetarian"],
    "allergies": ["nuts"],
    "budgetLevel": "medium",
    "cookingTime": "quick",
    "isActive": false,
    "createdBy": "uuid",
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

### Activate Nutrition Plan
```http
POST /nutrition/plans/:id/activate
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Nutrition plan activated successfully"
}
```

### Get Meals
```http
GET /nutrition/meals
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `nutritionPlanId` (optional): Filter by nutrition plan
- `mealType` (optional): breakfast, lunch, dinner, snack
- `date` (optional): ISO date string

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "nutritionPlanId": "uuid",
      "name": "Grilled Chicken Salad",
      "mealType": "lunch",
      "calories": 450,
      "proteinG": 35,
      "carbsG": 30,
      "fatG": 15,
      "fiberG": 8,
      "instructions": [
        "Grill chicken breast",
        "Chop vegetables",
        "Mix together"
      ],
      "ingredients": [
        {
          "name": "Chicken breast",
          "quantity": 200,
          "unit": "g"
        },
        {
          "name": "Mixed greens",
          "quantity": 100,
          "unit": "g"
        }
      ],
      "prepTimeMinutes": 15,
      "photoUrl": "https://..."
    }
  ]
}
```

### Create Meal
```http
POST /nutrition/meals
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "nutritionPlanId": "uuid",
  "name": "Oatmeal with Berries",
  "mealType": "breakfast",
  "calories": 350,
  "proteinG": 12,
  "carbsG": 60,
  "fatG": 8,
  "fiberG": 10,
  "instructions": [
    "Cook oats with water",
    "Add berries",
    "Top with honey"
  ],
  "ingredients": [
    {
      "name": "Oats",
      "quantity": 50,
      "unit": "g"
    },
    {
      "name": "Berries",
      "quantity": 100,
      "unit": "g"
    }
  ],
  "prepTimeMinutes": 10
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "nutritionPlanId": "uuid",
    "name": "Oatmeal with Berries",
    "mealType": "breakfast",
    "calories": 350,
    "proteinG": 12,
    "carbsG": 60,
    "fatG": 8,
    "fiberG": 10,
    "instructions": [
      "Cook oats with water",
      "Add berries",
      "Top with honey"
    ],
    "ingredients": [
      {
        "name": "Oats",
        "quantity": 50,
        "unit": "g"
      },
      {
        "name": "Berries",
        "quantity": 100,
        "unit": "g"
      }
    ],
    "prepTimeMinutes": 10,
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

### Get Food Logs
```http
GET /nutrition/food-logs
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `date` (optional): ISO date string
- `mealType` (optional): breakfast, lunch, dinner, snack

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "mealId": "uuid",
      "date": "2024-01-15",
      "mealType": "lunch",
      "foodName": "Grilled Chicken Salad",
      "calories": 450,
      "proteinG": 35,
      "carbsG": 30,
      "fatG": 15,
      "fiberG": 8,
      "servingSize": "1 serving",
      "loggedAt": "2024-01-15T12:00:00Z"
    }
  ]
}
```

### Create Food Log
```http
POST /nutrition/food-logs
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "mealId": "uuid",
  "date": "2024-01-15",
  "mealType": "lunch",
  "foodName": "Grilled Chicken Salad",
  "calories": 450,
  "proteinG": 35,
  "carbsG": 30,
  "fatG": 15,
  "fiberG": 8,
  "servingSize": "1 serving"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "mealId": "uuid",
    "date": "2024-01-15",
    "mealType": "lunch",
    "foodName": "Grilled Chicken Salad",
    "calories": 450,
    "proteinG": 35,
    "carbsG": 30,
    "fatG": 15,
    "fiberG": 8,
    "servingSize": "1 serving",
    "loggedAt": "2024-01-15T12:00:00Z"
  }
}
```

### Search Food Database
```http
GET /nutrition/food-database/search
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `query` (required): Search query
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "foods": [
      {
        "id": "uuid",
        "name": "Chicken Breast, Grilled",
        "brand": "Generic",
        "calories": 165,
        "proteinG": 31,
        "carbsG": 0,
        "fatG": 3.6,
        "fiberG": 0,
        "servingSize": "100g",
        "barcode": "1234567890"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "totalPages": 3
    }
  }
}
```

### Scan Barcode
```http
POST /nutrition/food-database/barcode-scan
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "barcode": "1234567890"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Chicken Breast, Grilled",
    "brand": "Generic",
    "calories": 165,
    "proteinG": 31,
    "carbsG": 0,
    "fatG": 3.6,
    "fiberG": 0,
    "servingSize": "100g",
    "barcode": "1234567890"
  }
}
```

### Get Recipe Suggestions
```http
GET /nutrition/recipes/suggestions
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `ingredients` (optional): Comma-separated list of ingredients
- `mealType` (optional): breakfast, lunch, dinner, snack
- `calories` (optional): Maximum calories

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Chicken Stir Fry",
      "mealType": "dinner",
      "calories": 450,
      "proteinG": 35,
      "carbsG": 30,
      "fatG": 15,
      "ingredients": [
        "Chicken breast",
        "Broccoli",
        "Bell peppers",
        "Soy sauce"
      ],
      "prepTimeMinutes": 20,
      "instructions": [
        "Cut chicken into strips",
        "Stir fry vegetables",
        "Add chicken and sauce",
        "Serve hot"
      ]
    }
  ]
}
```

### Get Ingredient Substitutions
```http
POST /nutrition/recipes/substitutions
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "ingredients": ["chicken breast", "broccoli"],
  "availableIngredients": ["tofu", "spinach", "bell peppers"]
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "substitutions": [
      {
        "original": "chicken breast",
        "substitute": "tofu",
        "reason": "Similar protein content",
        "ratio": "1:1"
      },
      {
        "original": "broccoli",
        "substitute": "spinach",
        "reason": "Similar nutritional profile",
        "ratio": "1:1"
      }
    ]
  }
}
```

---

## Coach Endpoints

### Get Coaches
```http
GET /coaches
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `specialty` (optional): Filter by specialty
- `rating` (optional): Minimum rating
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "coaches": [
      {
        "id": "uuid",
        "userId": "uuid",
        "firstName": "Sarah",
        "lastName": "Johnson",
        "certification": "NASM-CPT",
        "yearsExperience": 5,
        "specialties": ["strength", "weight loss"],
        "bio": "Certified personal trainer with 5 years experience",
        "hourlyRate": 50,
        "maxClients": 20,
        "currentClients": 15,
        "rating": 4.8,
        "totalReviews": 45,
        "isVerified": true,
        "isActive": true,
        "profileImageUrl": "https://..."
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "totalPages": 3
    }
  }
}
```

### Get Coach by ID
```http
GET /coaches/:id
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "userId": "uuid",
    "firstName": "Sarah",
    "lastName": "Johnson",
    "certification": "NASM-CPT",
    "yearsExperience": 5,
    "specialties": ["strength", "weight loss"],
    "bio": "Certified personal trainer with 5 years experience",
    "hourlyRate": 50,
    "maxClients": 20,
    "currentClients": 15,
    "rating": 4.8,
    "totalReviews": 45,
    "availability": {
      "monday": ["09:00", "10:00", "11:00"],
      "tuesday": ["09:00", "10:00", "11:00"],
      "wednesday": ["09:00", "10:00", "11:00"],
      "thursday": ["09:00", "10:00", "11:00"],
      "friday": ["09:00", "10:00", "11:00"]
    },
    "isVerified": true,
    "isActive": true,
    "profileImageUrl": "https://..."
  }
}
```

### Get Coach Assignments
```http
GET /coaches/assignments
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "userId": "uuid",
      "coachId": "uuid",
      "coachName": "Sarah Johnson",
      "assignedAt": "2024-01-01T00:00:00Z",
      "status": "active",
      "notes": "Focus on strength training"
    }
  ]
}
```

### Create Coach Assignment
```http
POST /coaches/assignments
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "coachId": "uuid",
  "notes": "Focus on strength training"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "userId": "uuid",
    "coachId": "uuid",
    "assignedAt": "2024-01-15T00:00:00Z",
    "status": "active",
    "notes": "Focus on strength training"
  }
}
```

### Get Daily Reports
```http
GET /coaches/daily-reports
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `date` (optional): ISO date string
- `userId` (optional): Filter by user

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "userId": "uuid",
      "userName": "John Doe",
      "reportDate": "2024-01-15",
      "sleepHours": 7.5,
      "sleepQuality": 8,
      "restingHeartRate": 65,
      "avgHeartRate": 75,
      "maxHeartRate": 145,
      "workoutCompleted": true,
      "workoutDurationMinutes": 45,
      "workoutIntensity": "moderate",
      "caloriesConsumed": 2500,
      "proteinConsumedG": 150,
      "carbsConsumedG": 250,
      "fatConsumedG": 80,
      "waterConsumedMl": 2500,
      "moodRating": 8,
      "energyLevel": 7,
      "stressLevel": 4,
      "motivationLevel": 8,
      "aiInsights": {
        "trends": ["Sleep quality improving"],
        "concerns": ["Protein intake slightly low"],
        "recommendations": ["Increase protein by 20g"]
      },
      "coachNotes": "",
      "coachRecommendations": {}
    }
  ]
}
```

### Create Daily Report
```http
POST /coaches/daily-reports
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "userId": "uuid",
  "reportDate": "2024-01-15",
  "sleepHours": 7.5,
  "sleepQuality": 8,
  "restingHeartRate": 65,
  "avgHeartRate": 75,
  "maxHeartRate": 145,
  "workoutCompleted": true,
  "workoutDurationMinutes": 45,
  "workoutIntensity": "moderate",
  "caloriesConsumed": 2500,
  "proteinConsumedG": 150,
  "carbsConsumedG": 250,
  "fatConsumedG": 80,
  "waterConsumedMl": 2500,
  "moodRating": 8,
  "energyLevel": 7,
  "stressLevel": 4,
  "motivationLevel": 8
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "userId": "uuid",
    "reportDate": "2024-01-15",
    "sleepHours": 7.5,
    "sleepQuality": 8,
    "restingHeartRate": 65,
    "avgHeartRate": 75,
    "maxHeartRate": 145,
    "workoutCompleted": true,
    "workoutDurationMinutes": 45,
    "workoutIntensity": "moderate",
    "caloriesConsumed": 2500,
    "proteinConsumedG": 150,
    "carbsConsumedG": 250,
    "fatConsumedG": 80,
    "waterConsumedMl": 2500,
    "moodRating": 8,
    "energyLevel": 7,
    "stressLevel": 4,
    "motivationLevel": 8,
    "aiInsights": {
      "trends": ["Sleep quality improving"],
      "concerns": ["Protein intake slightly low"],
      "recommendations": ["Increase protein by 20g"]
    },
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

### Update Daily Report
```http
PUT /coaches/daily-reports/:id
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "coachNotes": "Great progress! Keep up the good work.",
  "coachRecommendations": {
    "workout": "Increase weight by 5kg next session",
    "nutrition": "Add 20g more protein"
  }
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "coachNotes": "Great progress! Keep up the good work.",
    "coachRecommendations": {
      "workout": "Increase weight by 5kg next session",
      "nutrition": "Add 20g more protein"
    }
  }
}
```

### Get Coach Clients
```http
GET /coaches/:id/clients
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "userId": "uuid",
      "firstName": "John",
      "lastName": "Doe",
      "assignedAt": "2024-01-01T00:00:00Z",
      "status": "active",
      "progress": {
        "+weight": 2.3,
        "mood": "good"
      },
      "lastActive": "2024-01-15T09:00:00Z"
    }
  ]
}
```

---

## AI Endpoints

### Pose Estimation
```http
POST /ai/pose-estimate
```

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

**Request Body:**
- `video`: Video file (MP4, MOV)
- `exerciseId`: Exercise UUID

**Response (200):**
```json
{
  "success": true,
  "data": {
    "repCount": 12,
    "formScore": 92.5,
    "formIssues": [
      {
        "timestamp": 5.2,
        "issue": "Back not straight",
        "severity": "medium"
      }
    ],
    "keypoints": [
      {
        "name": "nose",
        "x": 0.5,
        "y": 0.1,
        "confidence": 0.95
      }
    ]
  }
}
```

### AI Chat
```http
POST /ai/chat
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "message": "What's the best exercise for chest?",
  "context": "workout"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "response": "The best exercises for chest include bench press, push-ups, and chest fly. For beginners, I recommend starting with push-ups...",
    "suggestions": [
      "How do I do a proper push-up?",
      "What's the difference between incline and decline bench press?"
    ],
    "relatedExercises": [
      {
        "id": "uuid",
        "name": "Bench Press",
        "category": "strength"
      }
    ]
  }
}
```

### Workout Recommendation
```http
POST /ai/workout-recommendation
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "goal": "muscle_gain",
  "fitnessLevel": "intermediate",
  "equipment": "gym",
  "duration": 45,
  "focus": "upper_body"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "workout": {
      "name": "Upper Body Hypertrophy",
      "duration": 45,
      "exercises": [
        {
          "id": "uuid",
          "name": "Bench Press",
          "sets": 4,
          "reps": 8,
          "rest": 90
        },
        {
          "id": "uuid",
          "name": "Overhead Press",
          "sets": 3,
          "reps": 10,
          "rest": 60
        }
      ]
    },
    "reasoning": "This workout focuses on compound movements for maximum muscle growth..."
  }
}
```

### Nutrition Recommendation
```http
POST /ai/nutrition-recommendation
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "goal": "muscle_gain",
  "weightKg": 75,
  "heightCm": 180,
  "activityLevel": "moderate",
  "dietaryRestrictions": []
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "dailyCalories": 2800,
    "macros": {
      "protein": 180,
      "carbs": 280,
      "fat": 90
    },
    "mealPlan": {
      "breakfast": "Oatmeal with protein powder",
      "lunch": "Grilled chicken with rice",
      "dinner": "Salmon with vegetables",
      "snacks": "Greek yogurt, nuts"
    },
    "reasoning": "Based on your goals and activity level, you need a caloric surplus with high protein..."
  }
}
```

### Analyze Progress
```http
POST /ai/analyze-progress
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "timeframe": "30d",
  "metrics": ["weight", "workouts", "nutrition"]
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "trends": {
      "weight": "+1.2kg",
      "workouts": "12 completed",
      "nutrition": "85% compliance"
    },
    "insights": [
      "Consistent workout schedule",
      "Protein intake could be improved",
      "Sleep quality is excellent"
    ],
    "recommendations": [
      "Increase protein by 20g daily",
      "Add one more rest day per week",
      "Continue current workout routine"
    ],
    "predictions": {
      "weightIn30Days": "+1.5kg",
      "strengthGain": "+5%"
    }
  }
}
```

### Form Correction
```http
POST /ai/form-correction
```

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

**Request Body:**
- `video`: Video file (MP4, MOV)
- `exerciseId`: Exercise UUID

**Response (200):**
```json
{
  "success": true,
  "data": {
    "overallScore": 85,
    "corrections": [
      {
        "timestamp": 3.5,
        "issue": "Knees caving in",
        "correction": "Push knees outward throughout the movement",
        "severity": "high"
      },
      {
        "timestamp": 7.2,
        "issue": "Back rounding",
        "correction": "Keep your back straight and core tight",
        "severity": "medium"
      }
    ],
    "positiveFeedback": [
      "Good depth on squats",
      "Controlled tempo"
    ]
  }
}
```

---

## Notification Endpoints

### Get Notifications
```http
GET /notifications
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `isRead` (optional): Filter by read status
- `type` (optional): Filter by type
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "uuid",
        "type": "workout_reminder",
        "title": "Workout Reminder",
        "body": "Don't forget your workout today at 5 PM",
        "data": {
          "workoutId": "uuid",
          "scheduledTime": "2024-01-15T17:00:00Z"
        },
        "isRead": false,
        "createdAt": "2024-01-15T16:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "totalPages": 3
    }
  }
}
```

### Mark Notification as Read
```http
PUT /notifications/:id/read
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "isRead": true,
    "readAt": "2024-01-15T16:30:00Z"
  }
}
```

### Mark All Notifications as Read
```http
PUT /notifications/read-all
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Marked all notifications as read"
}
```

### Update Notification Settings
```http
POST /notifications/settings
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "workoutReminders": true,
  "mealReminders": true,
  "progressUpdates": true,
  "coachMessages": true,
  "pushNotifications": true,
  "emailNotifications": false,
  "smsNotifications": false
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "workoutReminders": true,
    "mealReminders": true,
    "progressUpdates": true,
    "coachMessages": true,
    "pushNotifications": true,
    "emailNotifications": false,
    "smsNotifications": false
  }
}
```

---

## Error Responses

All endpoints may return error responses in the following format:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message description",
    "details": {}
  }
}
```

### Common Error Codes

- `UNAUTHORIZED` (401): Invalid or missing authentication token
- `FORBIDDEN` (403): User does not have permission to access this resource
- `NOT_FOUND` (404): Resource not found
- `VALIDATION_ERROR` (400): Request validation failed
- `CONFLICT` (409): Resource already exists or conflict with current state
- `INTERNAL_SERVER_ERROR` (500): Unexpected server error
- `SERVICE_UNAVAILABLE` (503): Service temporarily unavailable

### Example Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "email": "Invalid email format",
      "password": "Password must be at least 8 characters"
    }
  }
}
```

---

## Rate Limiting

API requests are rate limited based on user tier:

- **Free Tier:** 100 requests/hour
- **Premium Tier:** 1000 requests/hour
- **Admin:** Unlimited

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

---

## WebSocket Endpoints

### Connection
```
wss://api.shapeshred.com/ws
```

### Authentication
Send authentication message immediately after connection:

```json
{
  "type": "auth",
  "token": "access_token"
}
```

### Events

**Coach Chat**
```json
{
  "type": "message",
  "conversationId": "uuid",
  "senderId": "uuid",
  "receiverId": "uuid",
  "messageType": "text",
  "content": "Hello coach!"
}
```

**Workout Updates**
```json
{
  "type": "workout_update",
  "sessionId": "uuid",
  "data": {
    "repCount": 10,
    "formScore": 95
  }
}
```

**Real-time Notifications**
```json
{
  "type": "notification",
  "data": {
    "type": "workout_reminder",
    "title": "Workout Reminder",
    "body": "Don't forget your workout today"
  }
}
```

---

## SDKs

Official SDKs are available for:

- JavaScript/TypeScript
- Swift (iOS)
- Kotlin (Android)
- Python

See the [SDK Documentation](./SDKS.md) for more details.
