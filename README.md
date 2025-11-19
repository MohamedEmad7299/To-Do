# UpTodo - Flutter Task Management App

A feature-rich, production-ready task management application built with Flutter, featuring Firebase backend, multi-authentication support, and a beautiful dark-themed UI.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?style=flat&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?style=flat&logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

### Authentication
- **Email/Password** - Traditional sign-up and login
- **Google Sign-In** - OAuth integration
- **Facebook Login** - Social authentication
- **Biometric Auth** - Fingerprint/Face ID support
- **Password Reset** - Email-based recovery
- **Secure Storage** - Encrypted credential management

### Task Management
- Create, read, update, and delete tasks
- Custom categories with icons
- Priority levels (Low, Medium, High)
- Due date and time scheduling
- Task completion tracking
- Auto-delete completed tasks after 24 hours
- Real-time sync with Firestore

### Calendar View
- Monthly calendar display
- Date-based task filtering
- Visual task indicators
- Week view navigation

### Focus Mode
- Pomodoro-style timer (30 minutes)
- Weekly focus statistics
- Do Not Disturb mode control
- App usage tracking

### Profile & Settings
- Customizable user avatar
- Task statistics dashboard
- Multi-language support (English/Arabic)
- Theme customization
- Account management

## Screenshots

<!-- Add your screenshots here -->
<!--
<p align="center">
  <img src="screenshots/splash.png" width="200" />
  <img src="screenshots/home.png" width="200" />
  <img src="screenshots/tasks.png" width="200" />
  <img src="screenshots/profile.png" width="200" />
</p>
-->

## Tech Stack

| Category | Technologies |
|----------|-------------|
| **Framework** | Flutter 3.10+, Dart 3.10+ |
| **State Management** | flutter_bloc 9.1.0 |
| **Navigation** | go_router 16.3.0 |
| **Backend** | Firebase (Auth, Firestore) |
| **Authentication** | firebase_auth, google_sign_in, flutter_facebook_auth, local_auth |
| **Storage** | flutter_secure_storage, shared_preferences |
| **UI/UX** | google_fonts, flutter_svg, cached_network_image |

## Architecture

The project follows **Clean Architecture** with the **BLoC Pattern** for state management:

```
lib/
├── core/                    # Core functionality
│   ├── constants/           # App configuration
│   ├── locale/              # Localization BLoC
│   ├── routing/             # GoRouter setup
│   ├── services/            # Business logic services
│   ├── shared_widgets/      # Reusable UI components
│   ├── style/               # Colors & text styles
│   ├── theme/               # Theme management
│   └── utils/               # Utilities & validators
│
├── features/                # Feature modules
│   ├── splash/              # Splash screen
│   ├── on_boarding/         # Onboarding flow
│   ├── welcome/             # Welcome screen
│   ├── authentication/      # Auth (login/register/reset)
│   └── bottom_nav_pages/    # Main app screens
│       ├── home/            # Home with task creation
│       ├── tasks/           # Task list & details
│       ├── calender/        # Calendar view
│       ├── focus/           # Focus timer
│       └── profile/         # User profile & settings
│
├── l10n/                    # Localization files
└── main.dart                # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.10 or higher
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/uptodo.git
   cd uptodo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable **Authentication** with Email/Password, Google, and Facebook providers
   - Enable **Cloud Firestore** database
   - Download configuration files:
     - Android: Place `google-services.json` in `android/app/`
     - iOS: Place `GoogleService-Info.plist` in `ios/Runner/`

4. **Configure OAuth Providers**

   **Google Sign-In:**
   - Add SHA-1 fingerprint to Firebase project
   - Update `app_config.dart` with your Web Client ID

   **Facebook Login:**
   - Create Facebook App at [Facebook Developers](https://developers.facebook.com/)
   - Configure `AndroidManifest.xml` and `Info.plist`

5. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Configuration

### Firestore Database Structure

```
tasks/
└── {taskId}/
    ├── userId: string
    ├── name: string
    ├── description: string
    ├── tag: string
    ├── priority: number
    ├── dateTime: timestamp
    ├── isCompleted: boolean
    ├── createdAt: timestamp
    └── completedAt: timestamp (nullable)
```

### Localization

The app supports multiple languages. Add new translations in `lib/l10n/`:

- `app_en.arb` - English
- `app_ar.arb` - Arabic

To add a new language:
1. Create `app_XX.arb` file
2. Add locale to `l10n.yaml`
3. Run `flutter gen-l10n`

## Dependencies

```yaml
dependencies:
  # State Management
  bloc: 9.1.0
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7

  # Navigation
  go_router: ^16.3.0

  # Firebase
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cloud_firestore: ^6.1.0

  # Authentication
  google_sign_in: ^7.2.0
  flutter_facebook_auth: ^7.1.2
  local_auth: ^3.0.0

  # Storage
  flutter_secure_storage: ^9.2.4
  shared_preferences: ^2.2.2

  # UI/UX
  google_fonts: ^6.3.2
  flutter_svg: ^2.2.1
  cached_network_image: ^3.4.1
  smooth_page_indicator: ^1.2.1

  # Utilities
  intl: ^0.20.2
  image_picker: ^1.1.2
  url_launcher: ^6.3.1
  path_provider: ^2.1.5
```

## Theme

The app features a beautiful dark theme with a lavender purple accent:

- **Primary Color:** `#8875FF`
- **Secondary Color:** `#8687E7`
- **Background:** `#121212`
- **Surface:** `#1D1D1D`

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use BLoC pattern for state management
- Write meaningful commit messages
- Add comments for complex logic

## Roadmap

- [ ] Push notifications for task reminders
- [ ] Task search functionality
- [ ] Recurring tasks
- [ ] Task sharing between users
- [ ] Offline mode improvements
- [ ] Widget for home screen
- [ ] Apple Sign-In
- [ ] Export/backup functionality

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Firebase](https://firebase.google.com/) - Backend services
- [BLoC Library](https://bloclibrary.dev/) - State management
- Icons and illustrations from the Flutter community

---

<p align="center">
  Made with Flutter
</p>