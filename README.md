# MovieStash 🎬

MovieStash is a Flutter app to discover, save, and revisit movies with an offline-first experience. It features fast lists for Trending and Now Playing, powerful search, detailed movie pages, and a robust bookmarking system that stays consistent across the app. The app embraces clean architecture with repository/use case layers, Cubit for state management, Hive for local caching, Dio + Retrofit networking, and GoRouter with a shell/IndexedStack for tabbed navigation.

Platforms:
- Android, iOS (full support)
- Web (buildable; feature parity may vary depending on packages)

---

## 🎥 Demo

Add a video or GIF showcasing the app (Home, Search, Details, Bookmarks).
- Tip: On GitHub, drag-and-drop a video/GIF into the README or link to a GitHub asset.

---

## 🌟 Features

- **Offline‑First Caching**: Fast cold starts and offline reading with Hive‑backed storage.
- **Deep Links**: Opens specific screens directly via GoRouter URL parsing.
- **Bookmark Sync**: Bookmarks propagate instantly across the app via a broadcast stream.
- **Debounced Search**: Snappy, network‑efficient search with input debouncing.
- **GoRouter Navigation**: Shell route for persistent tabs and a full‑screen details route.
- **Dependency Injection**: Flexible wiring and easy mocking with GetIt + Injectable.
- **Dio + Retrofit API**: Strongly‑typed endpoints for reliable, testable networking.
- **Unit Tests**: Repository tests cover online/offline flows, cache fallbacks, and sync notifications.
- **Clean Architecture**: Structured layers (Domain, Data, Presentation) for maintainability and scalability.


---

## 📁 Folder Structure

```plaintext
lib
├── core
│   ├── constants
│   │   └── api_constants.dart
│   ├── di
│   │   ├── injection_container.config.dart
│   │   ├── injection_container.dart
│   │   └── register_module.dart
│   ├── error
│   │   └── exceptions.dart
│   ├── local_storage
│   │   ├── hive_service_impl.dart
│   │   └── hive_service.dart
│   ├── network
│   │   ├── http_client_service_impl.dart
│   │   └── http_client_service.dart
│   ├── router
│   │   └── app_router.dart
│   ├── usecases
│   │   └── usecase.dart
│   └── utils
│       └── result.dart
├── data
│   ├── datasources
│   │   ├── movie_api_service.dart          
│   │   ├── movie_api_service.g.dart
│   │   ├── movie_local_data_source.dart     
│   │   └── movie_local_data_source_impl.dart
│   ├── models
│   │   ├── movie_model.dart                
│   │   ├── movie_model.g.dart
│   │   ├── movie_detail_model.dart         
│   │   └── movie_detail_model.g.dart
│   └── repositories
│       └── movie_repository_impl.dart    
├── domain
│   ├── entities
│   │   ├── movie.dart
│   │   └── movie_detail.dart
│   ├── repositories
│   │   └── movie_repository.dart
│   └── usecases
│       ├── bookmark_usecases.dart
│       ├── get_movie_detail.dart
│       ├── get_now_playing_movies.dart
│       ├── get_trending_movies.dart
│       ├── listen_to_bookmark_changes.dart
│       └── search_movies.dart
├── presentation
│   ├── bloc
│   │   ├── bookmarks
│   │   │   ├── bookmarks_cubit.dart
│   │   │   └── bookmarks_state.dart
│   │   ├── home
│   │   │   ├── home_cubit.dart
│   │   │   └── home_state.dart
│   │   ├── movie_detail
│   │   │   ├── movie_detail_cubit.dart
│   │   │   └── movie_detail_state.dart
│   │   └── search
│   │       ├── search_cubit.dart
│   │       └── search_state.dart
│   ├── pages
│   │   ├── bookmarks
│   │   │   └── bookmarks_page.dart
│   │   ├── home
│   │   │   └── home_page.dart
│   │   ├── movie_detail
│   │   │   └── movie_detail_page.dart
│   │   ├── search
│   │   │   └── search_page.dart
│   │   └── shell
│   │       └── shell_page.dart
│   └── widgets
│       ├── movie_card_widget/
│       │   ├── movie_card_widget.dart
│       │   ├── movie_info.dart
│       │   ├── movie_poster_image.dart
│       │   └── remove_bookmark_button.dart
│       ├── movie_list_widget.dart
│       └── shimmer_loading.dart
└── main.dart
```

---

## 🔧 Dependencies

Here's a list of all the packages used in this project, with brief descriptions of each:

```plaintext
dependencies:
  flutter:
    sdk: flutter                            # UI toolkit for building natively compiled applications.

  # State Management
  flutter_bloc: ^8.1.3                       # Predictable state management using the BLoC pattern.
  equatable: ^2.0.5                          # Simplifies object comparison without boilerplate code.
  
  # Networking
  retrofit: ^4.0.3                           # Type-safe REST client with code generation.
  dio: ^5.3.2                                # Powerful HTTP client for Dart.
  json_annotation: ^4.8.1                    # Defines API for JSON serialization/deserialization.
  
  # Local Database
  hive: ^2.2.3                               # Lightweight and fast key-value database.
  hive_flutter: ^1.1.0                       # Integrates Hive with Flutter.
  
  # Dependency Injection
  get_it: ^7.6.4                             # Simple service locator for dependency injection.
  injectable: ^2.3.2                         # Code generator for GetIt.
  
  # Navigation & Deep Linking
  go_router: ^12.1.1                         # Declarative routing package for navigation and deep linking.
  
  # UI Components
  cached_network_image: ^3.3.0               # Efficiently loads and caches network images.
  shimmer: ^3.0.0                            # Provides a shimmering loading effect.
  
  # Utilities
  connectivity_plus: ^5.0.1                  # Checks network connectivity status.
  share_plus: ^7.2.1                         # Shares content from your app.
  flutter_dotenv: ^6.0.0                     # Loads environment variables from a .env file.
  mockito: ^5.4.5                            # Mocking framework for unit testing.
  
dev_dependencies:
  build_runner: ^2.4.7                       # Tool that runs code generators.
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1                     # Code generator for Hive type adapters.
  injectable_generator: ^2.4.1               # Code generator for `injectable`.
  json_serializable: ^6.7.1                  # Generates boilerplate code for JSON serialization.
  retrofit_generator: ^8.0.4                 # Code generator for `retrofit`.
  very_good_analysis: ^6.0.0                 # Static analysis package with strict lint rules.

```

## 🔑 Setup

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/divyansh04/moviestash.git
   cd moviestash
   ```

2. **Install Packages**:

   ```bash
   flutter pub get
   ```

3. **TmDB API Key**:
   
   - Use the TmDB api [https://developers.themoviedb.org/3/getting-started/introduction].
   - Add your API key to a `.env` file in your project's root folder:
        TMDB_API_KEY=[YOUR_API_KEY]

4. **Run the App**:

   ```bash
   flutter run
   ```

---

## 🔍 Future Scope

- **Additional Unit Tests**: Enhance test coverage for services, Cubits, and UI.
- **Pagination**: wire page params through repository/local source; UI already structured for load-next-page.
- **Staleness policy**: store timestamps in cache and invalidate after a window.
- **App Theming**: Add dynamic color (Material You), dark/light themes, and per‑user theme preferences persisted locally.