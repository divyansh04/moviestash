import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviestash/core/constants/api_constants.dart';
import 'package:moviestash/domain/entities/movie.dart';

class MoviePosterWidget extends StatelessWidget {
  const MoviePosterWidget({
    required this.movie,
    required this.imageHeight,
    super.key,
  });

  final Movie movie;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl:
            movie.posterPath!=null && movie.posterPath!.isNotEmpty
                ? '${ApiConstants.imageBaseUrl}${movie.posterPath}'
                : '',
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              height: imageHeight,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget:
            (context, url, error) => Container(
              height: imageHeight,
              color: Colors.grey[300],
              child: const Icon(Icons.movie, size: 64),
            ),
      ),
    );
  }
}
