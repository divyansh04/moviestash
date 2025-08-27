import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:moviestash/presentation/pages/bookmarks/bookmarks_page.dart';
import 'package:moviestash/presentation/pages/home/home_page.dart';
import 'package:moviestash/presentation/pages/movie_detail/movie_detail_page.dart';
import 'package:moviestash/presentation/pages/search/search_page.dart';
import 'package:moviestash/presentation/pages/shell/shell_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/home',
    routes: [
      // Shell Route with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellPage(navigationShell: navigationShell);
        },
        branches: [
          // Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Search Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          // Bookmarks Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookmarks',
                name: 'bookmarks',
                builder: (context, state) => const BookmarksPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/movie/:id',
        name: 'movie-detail',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailPage(movieId: movieId);
        },
      ),

      // Deep Link Route for Shared Movies
      GoRoute(
        path: '/shared/movie/:id',
        name: 'shared-movie',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailPage(movieId: movieId);
        },
      ),
    ],
  );
}
