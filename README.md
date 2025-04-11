# Flutter Boilerplate App Architecture

This project follows a clean architecture approach, organized by features with a well-defined separation of concerns.

## Architecture Overview

The architecture is based on the following principles:
- **Clean Architecture**: Separation of concerns into distinct layers
- **Feature-first organization**: Code organized by feature rather than by layer
- **Dependency injection**: Using Riverpod for dependency management
- **Immutable state management**: Using Freezed for generating immutable classes
- **Code generation**: Leveraging riverpod_annotation for provider generation

## Project Structure

```
lib/
├── config/                    # Global configuration
│   ├── domain/                # Core domain classes (Failure, etc.)
│   ├── env/                   # Environment configuration
│   ├── infrastructure/        # Core infrastructure implementations
│   │   └── helpers/           # Common helper classes for repositories and services
│   └── providers/             # Global providers
│
├── core/                      # Shared utilities and components
│
├── features/                  # Application features
│   ├── auth/                  # Authentication feature
│   ├── chat/                  # Chat feature
│   │   ├── application/       # Business logic with StateNotifier
│   │   ├── domain/            # Domain models and entities
│   │   ├── infrastructure/    # Implementation layer
│   │   │   ├── DTO/           # Data Transfer Objects
│   │   │   ├── repositories/  # Repository implementations
│   │   │   └── services/      # API services
│   │   ├── presentation/      # UI components
│   │   │   └── widgets/       # Reusable UI components
│   │   └── providers/         # Feature-specific providers
│   │
│   └── home/                  # Home feature
│
└── main.dart                  # Application entry point
```

## Layer Guidelines

### Domain Layer
- Contains business entities with Freezed
- Represents core business concepts
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
- Services interact with external APIs using Dio
- Repositories implement business logic for data operations
- Leverages helper classes for common operations

### Presentation Layer
- Contains UI components (screens, widgets)
- Consumes state from Riverpod providers
- Handles user interactions
- Manages UI-related logic with ConsumerWidget pattern

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
The project uses code generation for Freezed models and Riverpod providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Error Handling
Errors are managed through a unified `Failure` class hierarchy, providing consistent error handling throughout the application. This is combined with the `Either` pattern from `dartz` to handle success and failure cases elegantly:

```dart
Future<Either<Failure, Result>> performOperation() async {
  try {
    // Operation logic
    return right(result);
  } on Exception catch (e) {
    return left(Failure.network(e.toString()));
  }
}
```

## Required Dependencies
The main dependencies used in this architecture:

```yaml
dependencies:
  flutter_riverpod: ^2.0.0
  riverpod_annotation: ^2.0.0
  freezed_annotation: ^2.0.0
  dartz: ^0.10.0
  dio: ^5.0.0

dev_dependencies:
  riverpod_generator: ^2.0.0
  freezed: ^2.0.0
  build_runner: ^2.0.0
```
