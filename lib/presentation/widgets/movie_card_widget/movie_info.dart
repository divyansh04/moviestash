import 'package:flutter/material.dart';
import 'package:moviestash/domain/entities/movie.dart';

class MovieInfo extends StatelessWidget {
  const MovieInfo({
    required this.movie,
    required this.showBookmarkAction,
    super.key,
  });

  final Movie movie;
  final bool showBookmarkAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            movie.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              if (movie.isBookmarked && !showBookmarkAction)
                const Icon(Icons.bookmark, color: Colors.blue, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
