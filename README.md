# Flutter Boilerplate App Architecture

This project follows a clean architecture approach, organized by features with a well-defined separation of concerns.

## Architecture Overview

The architecture is based on the following principles:
- **Clean Architecture**: Separation of concerns into layers
- **Feature-first organization**: Code organized by feature rather than by layer
- **Dependency injection**: Using providers for dependency management
- **Immutable state management**: Using Freezed for generating immutable classes

## Project Structure

```
lib/
├── config/              # Global configuration
│   ├── domain/          # Core domain classes (Failure, etc.)
│   ├── env/             # Environment configuration
│   ├── infrastructure/  # Core infrastructure implementations
│   └── providers/       # Global providers
│
├── core/                # Shared utilities and components
│
├── features/            # Application features
│   ├── auth/            # Authentication feature
│   ├── chat/            # Chat feature
│   │   ├── application/    # Business logic (Cubits/BLoCs)
│   │   ├── domain/         # Domain models and interfaces
│   │   ├── infrastructure/  # Repositories implementation
│   │   ├── presentation/   # UI components
│   │   └── providers/      # Feature-specific providers
│   │
│   └── home/            # Home feature
│
└── main.dart            # Application entry point
```

## Layer Guidelines

### Domain Layer
- Contains business entities
- Defines repository interfaces
- Contains use-cases or domain services
- Has no dependencies on other layers
- Uses plain Dart (no Flutter)

### Application Layer
- Manages application state using Cubits/BLoCs
- Implements use-cases from the domain layer
- Contains application logic
- Uses Freezed for immutable state management

### Infrastructure Layer
- Implements repositories from the domain layer
- Handles data sources (API, local storage)
- Maps data models to domain entities
- Manages caching and persistence strategies

### Presentation Layer
- Contains UI components (screens, widgets)
- Consumes state from the application layer
- Handles user interactions
- Manages UI-related logic

## State Management
The application uses Freezed for immutable state classes and handles state management primarily through Cubits/BLoCs.

## Dependency Management
Dependencies are injected using providers, allowing for:
- Easy testing through mocking
- Loose coupling between components
- Runtime configuration

## How to Generate Code
The project uses code generation for Freezed models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Error Handling
Errors are managed through a unified `Failure` class hierarchy, providing consistent error handling throughout the application.
