import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestash/presentation/bloc/bookmarks/bookmarks_cubit.dart';
import 'package:moviestash/presentation/widgets/movie_list_widget.dart';
import 'package:moviestash/presentation/widgets/shimmer_loading.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Movies',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksLoading) {
            return const ShimmerLoading();
          } else if (state is BookmarksLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No saved movies yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start bookmarking movies you love!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: MovieListWidget(
                movies: state.movies,
                isGrid: true,
                showBookmarkAction: true,
                onBookmarkRemoved: (movieId) {
                  context.read<BookmarksCubit>().removeBookmarkById(movieId);
                },
              ),
            );
          } else if (state is BookmarksError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () =>
                            context
                                .read<BookmarksCubit>()
                                .loadBookmarkedMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
