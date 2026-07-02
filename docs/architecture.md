# ShapeShred Architectural Definition

## 1. Overview
ShapeShred follows a **Feature-first Modular Architecture**. This approach ensures clear module boundaries, promotes decoupling, and supports long-term scalability as the application grows.

## 2. Module Structure
The project is organized into self-contained modules under the `features/` directory and a `core/` module for shared resources.

- `features/`: Contains feature-specific modules (e.g., `features/training`, `features/tracking`, `features/nutrition`). Each module encapsulates its own UI, domain logic, and data layer interfaces.
- `core/`: Contains shared resources used across features (e.g., networking clients, local storage, DI container, shared UI components, shared domain models).

## 3. Communication Patterns
- **Dependency Injection**: We use `get_it` for dependency injection to ensure modules remain decoupled.
- **Module Communication**: Modules do not directly depend on each other. They interact through interfaces exposed by the `core` module or via shared domain models.

## 4. Naming Conventions & Directory Structure
Each module (e.g., `features/feature_name`) follows this internal structure:
- `data/`: Data layer implementation (implementations of repositories).
- `domain/`: Domain layer (entities, repository interfaces, use cases).
- `presentation/`: UI layer (widgets, state management).

## 5. Infrastructure Abstraction
All external dependencies (Network, Storage) must be wrapped behind interfaces defined within the `core` module or the specific feature's `domain` layer (following the Repository Pattern). This facilitates easy mocking for unit testing and implementation swapping.
