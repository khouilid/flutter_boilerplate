# Flutter Boilerplate App Architecture

This project follows a clean architecture approach, organized by features with a well-defined separation of concerns.

## Architecture Overview

The architecture is based on the following principles:
- **Clean Architecture**: Separation of concerns into distinct layers
- **Feature-first organization**: Code organized by feature rather than by layer
- **Dependency injection**: Using Riverpod for dependency management
- **Immutable state management**: Using Freezed for generating immutable classes
- **Code generation**: Leveraging riverpod_annotation, freezed, json_serializable, and envied
- **Error monitoring**: Sentry integration for production error tracking
- **Environment configuration**: Multi-environment support with envied (.env.dev, .env.prod)

## Project Structure

```
lib/
├── core/                      # Shared utilities and components
│   ├── domain/                # Core domain classes
│   │   ├── failure.dart       # Failure types (server, storage, network, unknown)
│   │   ├── fresh.dart         # Data freshness wrapper with pagination support
│   │   └── remote_response.dart # Remote response wrapper (data/no connection)
│   ├── env/                   # Environment configuration (dev/prod)
│   ├── helpers/               # UI helpers (colors, text styles, enums)
│   ├── infrastructure/        # Core infrastructure implementations
│   │   ├── exceptions/        # Custom exceptions (DioException)
│   │   ├── extensions/        # Dio extensions for error classification
│   │   ├── helpers/           # Repository and service helpers
│   │   ├── http_client_config/ # Dio configuration and interceptors
│   │   └── secure_storage/    # Secure storage abstractions
│   ├── presentation/          # Shared UI components
│   │   ├── app_widget.dart    # Root MaterialApp widget
│   │   └── connectivity_watcher.dart # Global connectivity indicator
│   └── providers/             # Global providers (connectivity)
│
├── features/                  # Application features
│   ├── auth/                  # Authentication feature
│   │   └── providers/         # Auth-related providers
│   └── chat/                  # Chat feature
│       ├── application/       # Business logic with StateNotifier
│       ├── domain/            # Domain models and entities
│       ├── infrastructure/    # Implementation layer
│       │   ├── DTO/           # Data Transfer Objects
│       │   ├── repositories/  # Repository implementations
│       │   └── services/      # API services
│       ├── presentation/      # UI components
│       │   ├── screens/       # Feature screens
│       │   └── widgets/       # Reusable UI components
│       └── providers/         # Feature-specific providers
│
└── main.dart                  # Application entry point
```

## Layer Guidelines

### Domain Layer
- Contains business entities with Freezed
- Core classes: `Failure`, `Fresh<T>`, `RemoteResponse<T>`
- Has no dependencies on other layers
- Uses plain Dart (no Flutter)

### Application Layer
- Manages application state using Riverpod StateNotifier
- Contains pure business logic
- Maps between user actions and state changes
- Uses Freezed for immutable state management

### Infrastructure Layer
- Organized into DTO, repositories, and services
- DTOs handle data mapping between domain and external sources
- Services interact with external APIs using Dio with retrofit
- Repositories implement business logic for data operations
- Leverages helper mixins for common operations:
  - `RemoteServiceHelper`: Standardized HTTP response handling with Sentry reporting
  - `RepositoryHelper`: Error handling with Either pattern
  - `InternetConnectionService`: Connectivity checking utility

### Presentation Layer
- Contains UI components (screens, widgets)
- Consumes state from Riverpod providers
- Handles user interactions
- Uses ConsumerWidget and ConsumerStatefulWidget patterns

## Core Features

### HTTP Client Configuration
The app uses Dio with a robust interceptor chain:
- **DioInterceptor**: Authentication headers, base URL, timeouts
- **LoggingInterceptor**: Request/response logging with body inspection
- **RetryInterceptor**: Automatic retry with exponential backoff on transient network errors

### Error Handling
Errors are managed through multiple layers:
1. **Failure class**: Unified error types (server, storage, network, unknown)
2. **Either pattern**: From `dartz` for functional error handling
3. **Sentry integration**: Automatic error reporting for production monitoring
4. **Custom DioException**: Simplified error wrapping for the application layer

### Connectivity Monitoring
- Global `ConnectivityWatcher` widget displays a "Connecting..." indicator when offline
- `connectivityProvider` stream provider monitors network state changes
- `InternetConnectionService` utility for imperative connectivity checks

### Environment Configuration
- Multi-environment support using `envied`
- Separate `.env.dev` and `.env.prod` files
- Obfuscated environment variables for security
- Automatic environment selection based on build mode

## State Management
The application uses Riverpod's StateNotifier pattern with Freezed for immutable state classes:

```dart
@freezed
class FeatureState with _$FeatureState {
  const FeatureState._();
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.success() = _Success;
  const factory FeatureState.error(Failure failure) = _Error;
}
```

## Dependency Management
Dependencies are injected using Riverpod's code generation:

```dart
@Riverpod()
class FeatureRepository extends _$FeatureRepository {
  @override
  Future<void> build() async {
    // Initialize dependencies
  }
}
```

This approach provides:
- Type-safe dependency injection
- Easy testing through mocking
- Loose coupling between components
- Automatic dependency resolution

## Creating New Features
You can easily create new features using the provided script:

```bash
python create_feature.py feature_name
```

This will generate the complete feature structure following the project architecture.

## How to Generate Code
The project uses code generation for Freezed models, Riverpod providers, JSON serialization, and environment variables:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use the predefined scripts (with FVM):

```bash
# Initialize project (clean, get dependencies, build)
fvm flutter run init

# Build code generators
fvm flutter run build

# Watch for changes
fvm flutter run watch
```

## Required Dependencies
The main dependencies used in this architecture:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  freezed_annotation: ^2.0.0
  dartz: ^0.10.1
  dio: ^5.4.0
  connectivity_plus: ^6.1.3
  sentry_flutter: ^8.14.1
  envied: ^1.3.5
  flutter_secure_storage: ^4.2.1
  logger: ^2.4.0
  equatable: ^2.0.5
  json_annotation: ^4.9.0

dev_dependencies:
  riverpod_generator: ^2.3.9
  freezed: ^2.4.5
  build_runner: ^2.5.4
  retrofit_generator: ^9.0.0
  json_serializable: ^6.9.4
  envied_generator: ^1.1.1
  flutter_lints: ^2.0.0
```

## Flutter Version Management
This project uses [FVM](https://fvm.app/) for Flutter version management. Ensure FVM is installed and configured before running the project.
