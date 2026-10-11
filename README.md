# 🌍 WorldQuiz

> A production-grade Flutter geography quiz platform featuring an offline-first architecture, interactive map-based gameplay, and full bilingual support. Browse 250+ countries, challenge yourself across 5 quiz modes, and track your progress with streaks and timers.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-00BCD4?style=for-the-badge&logo=flutter&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-FFB300?style=for-the-badge&logo=hive&logoColor=black)
![flutter_map](https://img.shields.io/badge/flutter_map-4CAF50?style=for-the-badge&logo=leaflet&logoColor=white)

---

## Screenshots

| Home | Detail | Quiz Config | Map Quiz |
|---|---|---|---|
| *screenshot* | *screenshot* | *screenshot* | *screenshot* |

| Standard Quiz | Result | Dark Theme | Arabic RTL |
|---|---|---|---|
| *screenshot* | *screenshot* | *screenshot* | *screenshot* |

---

## Features

### 🎮 Quiz System

| Feature | Description |
|---|---|
| 5 Quiz Modes | Flag, Capital, Currency, Language, and Interactive Map |
| Difficulty Levels | Easy, Medium, and Hard with fair distractor generation |
| Continent Filter | Play quizzes scoped to specific continents |
| Timer System | 10-second countdown with visual progress bar |
| Streak Tracking | Fire icon displays consecutive correct answers |
| Animated Feedback | Shake animations for wrong answers, color-coded results |
| Confetti Celebrations | Particle effects for high scores |

### 🗺️ Interactive Map Quiz

- Tap-to-guess mechanic on a dark CartoDB tile layer
- Real-time distance calculation using `latlong2`
- Dynamic zoom levels based on country area
- Visual feedback with neon markers and connection lines

### 🌐 Bilingual Support

- Full English and Arabic translations
- Automatic RTL (Right-to-Left) layout switching
- Custom translation system without external localization packages

### 🎨 Theme System

- Dark/Light mode toggle with persistent preference
- Neon accent colors (Blue, Green, Red)
- Smooth transitions between themes

### 💾 Offline-First Architecture

- Complete country data cached locally with Hive
- Flag images cached via `cached_network_image`
- App fully functional without internet after first load
- Self-healing cache that validates and refetches when needed

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State Management | Riverpod (`AsyncNotifier`) |
| Local Database | Hive |
| HTTP Client | Dio |
| Maps | `flutter_map` + CartoDB Tiles |
| Geospatial Math | `latlong2` |
| Data Source | REST Countries API v5 |

---

## Architecture

```text
lib/
├── core/
│   ├── assets/images/
│   ├── theme/app_theme.dart
│   └── utils/quiz_helper.dart
├── models/
│   ├── country.dart
│   └── quiz_questions.dart
├── repositories/
│   ├── cache.dart  # Hive CRUD operations
│   └── country.dart           # Dio API calls
├── providers/
│   ├── country.dart  # AsyncNotifier with cache-first strategy
│   ├── quiz.dart     # Quiz state machine
│   ├── theme.dart    # Persistent theme mode
│   └── locale.dart   # Language state
├── screens/
│   ├── splash.dart
│   ├── country.dart
│   ├── country_detail.dart
│   ├── quiz_config.dart
│   ├── quiz_play.dart
│   ├── quiz_result.dart
│   └── map_quiz.dart
└── main.dart
```

### Data Flow

```text
UI → Provider → Repository → [Hive Cache / REST API] → Model
```

The UI never calls the API directly. All data flows through the repository layer, with the cache checked first for instant offline loads.

---

## Getting Started

### Prerequisites

- Flutter SDK
- REST Countries API key

### 1. Get the project

Clone the repository and open the project directory.

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Add your API key

Create a `.env` file in the project root:

```env
API_KEY=your_api_key_here
CARTO_API_KEY=your_api_key_here
```

Get a free API key at [restcountries.com](https://restcountries.com/).

### 4. Run the app

```bash
flutter run
```

### Dependencies

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
  dio: ^5.11.0
  google_fonts: ^8.2.1
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  flutter_launcher_icons: ^0.14.4
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  confetti: ^0.7.0
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  cached_network_image: ^3.3.1
```
---

## Testing

The project includes **30 tests** across 6 test files covering model parsing, localization, quiz logic, distractor generation, geospatial distance calculation, and widget rendering.

| Category | Tests | Focus |
|----------|-------|-------|
| Model Parsing | 3 | JSON deserialization, cache/API format safety |
| Localization | 6 | Translation lookup, key parity, fallbacks |
| Quiz Logic | 7 | Scoring, streaks, timer clamping, feedback |
| Distractor Generation | 7 | Option uniqueness, correct answer inclusion |
| Distance Calculation | 5 | Haversine accuracy, thresholds, edge cases |
| Widget Rendering | 2 | UI component presence, empty states |

```bash
flutter test 
```
---

## What I Learned


### Caching & Offline-First

- **Hive** for local NoSQL storage with type-safe boxes
- Cache-first loading strategy: check local → fallback to network
- Self-healing cache that detects stale data and refetches automatically
- Handling type mismatches between API responses and cached data

### Localization Without Packages

- Built a custom translation system using Dart Maps
- Automatic RTL layout flipping for Arabic
- Persistent language preference across app restarts

### Clean JSON Parsing

- Defensive parsing of deeply nested API structures
- Handling multiple data formats (Lists, Maps, primitives) gracefully
- Safe coordinate extraction from varying API response shapes

### UI/UX Polish

- Neon design system with glow effects and shadows
- Smooth animations (shake, slide, fade) for feedback
- Confetti particle system for gamification
- Responsive layouts that adapt to RTL languages
