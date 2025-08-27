import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moviestash/core/constants/api_constants.dart';
import 'package:moviestash/core/di/injection_container.dart';
import 'package:moviestash/domain/entities/movie_detail.dart';
import 'package:moviestash/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:moviestash/presentation/widgets/shimmer_loading.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailPage extends StatelessWidget {

  const MovieDetailPage({required this.movieId, super.key});
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieDetailCubit>()..load(movieId),
      child: Scaffold(
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const ShimmerLoading();
            } else if (state is MovieDetailLoaded) {
              final movie = state.movieDetail;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    leading: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.white38,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        onPressed: () {
                          final canPop = context.canPop();
                          if (canPop) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl:
                            '${ApiConstants.imageBaseUrl}${movie.backdropPath}',
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) =>
                                Container(color: Colors.grey[300]),
                        errorWidget:
                            (context, url, error) => const ColoredBox(
                              color: Colors.grey,
                              child: Icon(Icons.error),
                            ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        width: 120,
                                        height: 180,
                                        color: Colors.grey[300],
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        width: 120,
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie.voteAverage.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${movie.runtime} min',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      movie.releaseDate,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      () =>
                                          context
                                              .read<MovieDetailCubit>()
                                              .toggleBookmark(),
                                  icon: Icon(
                                    movie.isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                  label: Text(
                                    movie.isBookmarked
                                        ? 'Remove Bookmark'
                                        : 'Bookmark',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _shareMovie(movie),
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (movie.genres.isNotEmpty) ...[
                            const Text(
                              'Genres',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children:
                                  movie.genres
                                      .map(
                                        (genre) => Chip(
                                          label: Text(genre.name),
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          const Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is MovieDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<MovieDetailCubit>().load(movieId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _shareMovie(MovieDetail movie) {
    final shareText = '''
🎬 Check out this amazing movie!

${movie.title}
⭐ ${movie.voteAverage.toStringAsFixed(1)}/10

${movie.overview}

Open in MovieStash: moviestash://shared/movie/${movie.id}
  ''';

    Share.share(shareText);
  }
}
