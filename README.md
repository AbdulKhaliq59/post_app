# post_app

A Flutter application that displays a list of news posts fetched from a remote API. The app demonstrates clean architecture principles by separating concerns into data, domain, and UI layers, and uses the Provider package for state management and theme switching (light/dark mode).

## Features
- Fetches and displays news posts from an external API
- Clean separation of data, domain, and UI layers
- State management using Provider
- Light and dark theme support

## Clean Architecture Overview
The app is structured to promote maintainability, testability, and scalability:
- **Data Layer**: Handles API calls and data repositories
- **Domain Layer**: Contains business models (e.g., `Post`)
- **UI Layer**: Contains screens, viewmodel, widgets, and themes

## Folder Structure
See `FOLDER_STRUCTURE.md` for a diagram and explanation of the folder structure:

```plaintext
lib/
├── main.dart
├── data/
│   ├── repositories/
│   └── services/
├── domain/
│   └── models/
└── ui/
    ├── core/
    │   └── themes/
    └── post/
        ├── post_screen.dart
        ├── viewmodel/
        └── widgets/
```

- **main.dart**: App entry point, sets up providers and navigation.
- **data/**: Data access, API services, and repositories.
- **domain/**: Business models.
- **ui/**: Presentation layer, including themes, screens, viewmodels, and widgets.

## Environment Variables Setup
To keep sensitive data like API keys secure, this project uses a `.env` file. You should create a `.env` file in the root directory with the following content:

```env
API_KEY=your_news_api_key_here
```

> **Note:** Never commit your `.env` file to version control. Add `.env` to your `.gitignore`.

You may need to use a package like [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) to load environment variables in your Flutter app.

## How It Works
1. `main.dart` initializes the app, sets up theme and post providers.
2. The `PostViewModel` fetches posts using the `PostRepository`, which delegates to `PostApiService` for API calls.
3. The UI (`PostScreen`) listens to the viewmodel and displays posts, with theme switching available.

## Getting Started
1. Run `flutter pub get` to install dependencies.
2. Create a `.env` file as described above.
3. Run the app with `flutter run`.

---
For more details, see the code and the folder structure diagram in `FOLDER_STRUCTURE.md`.
