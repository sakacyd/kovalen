# Kovalen ??
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white) ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

Kovalen is an innovative matchmaking application specifically designed for university students, matching them based on academic interests, location, and learning styles.

## ?? Key Features
- **Smart Matchmaking**: Connects students using Gower's Coefficient matching logic and Haversine distance, considering learning goals, study programs, and interests.
- **Real-time Messaging**: Robust chat capabilities powered by Supabase Realtime for instant communication.
- **Academic Profiles**: Specialized student profiles tracking university, major, and semester data.
- **Study Groups**: Create or join study groups and monitor group activities (admin capabilities included).
- **Location-Based**: Filter potential connections based on geographical proximity.

## ??? Architecture
The app follows **Clean Architecture** principles, segregating the application into clear layers for maintainability and scalability:

- **Presentation Layer**: UI elements and state management using the `flutter_bloc` pattern (`Cubit` & `BLoC`).
- **Domain Layer**: Core business logic, entities, and use cases, entirely decoupled from Flutter and third-party packages (using `fpdart` for functional error handling).
- **Data Layer**: Data sources (Supabase), models, and repository implementations.

### ?? Folder Structure
```text
lib/
+-- core/           # Common utilities, constants, theme, and exceptions
+-- data/           # Data fetching (API/Supabase), DTO Models, and Repositories
+-- domain/         # Entities, abstract repositories, and UseCases
+-- presentation/   # UI Pages, Widgets, and BLoC state management
```

## ?? Getting Started

### Prerequisites
- Flutter SDK `^3.8.1`
- Dart SDK
- Supabase Project (Database & Auth)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/sakacyd/kovalen.git
   ```
2. Navigate into the project:
   ```bash
   cd kovalen
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Environment Variables:
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## ??? Build & Release
To build a production-ready APK:
```bash
flutter build apk --release
```
The output file will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## ??? Security & Performance
- **N+1 Query Elimination**: Carefully tailored PostgREST queries.
- **Functional Error Handling**: Usage of `fpdart` guarantees errors are explicitly handled and mapped to domain failures.
- **Resource Cleanup**: Stream controllers and channel subscriptions are efficiently closed to prevent memory leaks in Realtime channels.

---
*Built with ?? for better student collaborations.*
