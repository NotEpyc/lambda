# lambda

# Lambda 101 - Flutter Learning App

A modern Flutter application for learning programming, similar to the Lambda 101 website. This app is designed to be easily connected to a Railway backend and works seamlessly without authentication.

## Features

- 🚀 **Modern UI** - Clean, intuitive design inspired by the Lambda 101 website
- 📱 **Cross-platform** - Works on iOS, Android, Web, and Desktop
-  **Course Management** - Browse programming courses with rich content
- 📊 **Progress Tracking** - Track learning progress and completion
- 🏷️ **Categories** - Organized course categories
- 🔍 **Search** - Find courses easily
- 💾 **Offline Ready** - Works with mock data when backend is unavailable
- 🔓 **No Authentication Required** - Simple access to all features

## Getting Started

### Prerequisites

- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Railway account (for backend deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd lambda
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

The app will launch directly to the home screen with access to all courses and features.

## Railway Backend Integration

### Step 1: Deploy Your Backend to Railway

1. Create a new Railway project
2. Deploy your backend API to Railway
3. Note down your Railway app URL (e.g., `https://your-app.up.railway.app`)

### Step 2: Update API Configuration

1. Open `lib/config/app_config.dart`
2. Update the `apiBaseUrl` with your Railway URL:
   ```dart
   static const String apiBaseUrl = 'https://your-railway-app.up.railway.app/api';
   ```

### Step 3: Required API Endpoints

Your Railway backend should implement these endpoints:

#### Courses
- `GET /api/courses` - Get all courses
- `GET /api/courses/:id` - Get course by ID
- `GET /api/courses/search?q=query` - Search courses

#### Categories
- `GET /api/categories` - Get all categories

#### Progress (Optional)
- `GET /api/progress/course/:courseId` - Get course progress
- `PUT /api/progress/lesson/:lessonId` - Update lesson progress
- `POST /api/progress/lesson/:lessonId/complete` - Mark lesson complete
- `POST /api/progress/time` - Record time spent

## Architecture

```
lib/
├── config/          # App configuration
├── controllers/     # State management (Provider)
├── data/           # Mock data for development
├── models/         # Data models
├── screens/        # UI screens
│   ├── auth/       # Login/Register
│   ├── courses/    # Course listing
│   ├── home/       # Home dashboard
│   └── profile/    # User profile
└── services/       # API and storage services
```

## Dependencies

- `provider` - State management
- `http` - API calls
- `shared_preferences` - Local storage
- `cached_network_image` - Image caching

**Note**: This app is designed to work seamlessly with or without a backend. The mock data ensures you can develop and test the app independently while your Railway backend is being developed.
