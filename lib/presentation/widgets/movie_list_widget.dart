import 'package:flutter/material.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'movie_card_widget/movie_card_widget.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({
    required this.movies,
    super.key,
    this.isHorizontal = false,
    this.isGrid = false,
    this.showBookmarkAction = false,
    this.onBookmarkRemoved,
    this.scrollController,
    this.isLoadingMore = false,
    this.hasMore = true,
  });
  final List<Movie> movies;
  final bool isHorizontal;
  final bool isGrid;
  final bool showBookmarkAction;
  // ignore: inference_failure_on_function_return_type
  final Function(int)? onBookmarkRemoved;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCardWidget(
            movie: movies[index],
            showBookmarkAction: showBookmarkAction,
            onBookmarkRemoved:
                onBookmarkRemoved != null
                    ? () => onBookmarkRemoved!(movies[index].id)
                    : null,
          );
        },
      );
    }

    // Updated horizontal ListView
    if (isHorizontal) {
      return SizedBox(
        height: 320,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: movies.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < movies.length) {
              return MovieCardWidget(movie: movies[index], isHorizontal: true);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCardWidget(movie: movies[index]);
      },
    );
  }
}
