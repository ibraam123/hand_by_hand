/*
* lib/
│── core/
│   ├── config/            # App-level configs (theme, routes, constants)
│   ├── utils/             # Helpers (formatters, validators, etc.)
│   ├── services/          # Shared services (API, local DB, speech, AI SDK wrappers)
│   ├── widgets/           # Reusable UI components (buttons, loaders, error widgets)
│   └── bloc_observer.dart # Custom BlocObserver (for logging/debugging)
│
│── features/
│   ├── accessibility_map/ # Feature 1: Navigation for wheelchair users
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/  # Remote API or local DB sources
│   │   │   └── repositories/
│   │   ├── logic/         # BLoCs / Cubits
│   │   ├── presentation/  # Screens, Widgets
│   │   └── accessibility_map.dart
│   │
│   ├── sign_language/     # Feature 2: AI-powered sign language
│   │   ├── data/
│   │   ├── logic/
│   │   ├── presentation/
│   │   └── sign_language.dart
│   │
│   ├── success_stories/   # Feature 3: Inspiring stories
│   │   ├── data/
│   │   ├── logic/
│   │   ├── presentation/
│   │   └── success_stories.dart
│   │
│   ├── awareness/         # Feature 4: Family & community awareness
│   │   ├── data/
│   │   ├── logic/
│   │   ├── presentation/
│   │   └── awareness.dart
│   │
│   └── common/            # Shared between features (models, blocs, widgets)
│
│── app.dart               # App root (MaterialApp + routing setup)
│── main.dart              # Entry point
*/