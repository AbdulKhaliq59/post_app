```plaintext
lib/
├── main.dart
├── data/
│   ├── repositories/
│   │   └── post_repository.dart
│   └── services/
│       └── post_api_service.dart
├── domain/
│   └── models/
│       └── post.dart
└── ui/
    ├── core/
    │   └── themes/
    │       ├── app_theme.dart
    │       ├── dark_theme.dart
    │       └── light_theme.dart
    └── post/
        ├── post_screen.dart
        ├── viewmodel/
        │   └── post_view_model.dart
        └── widgets/
            └── post_card.dart
```

**Folder Structure Diagram Explanation:**
- `main.dart`: Entry point of the app, sets up providers and the main UI.
- `data/`: Handles data access, including API calls and repositories.
  - `repositories/`: Contains repository classes that abstract data sources.
  - `services/`: Contains services for network/API communication.
- `domain/`: Contains core business models (e.g., `Post`).
- `ui/`: Handles all user interface code.
  - `core/themes/`: Theme management (light/dark mode).
  - `post/`: UI for posts, including screens, viewmodels, and widgets.
