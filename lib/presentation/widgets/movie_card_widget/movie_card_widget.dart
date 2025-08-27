// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/presentation/widgets/movie_card_widget/movie_info.dart';
import 'package:moviestash/presentation/widgets/movie_card_widget/movie_poster_image.dart';
import 'package:moviestash/presentation/widgets/movie_card_widget/remove_bookmark_button.dart';

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({
    required this.movie,
    super.key,
    this.isHorizontal = false,
    this.showBookmarkAction = false,
    this.onBookmarkRemoved,
  });
  final Movie movie;
  final bool isHorizontal;
  final bool showBookmarkAction;
  final VoidCallback? onBookmarkRemoved;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = isHorizontal ? 210 : 200;
    return GestureDetector(
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Container(
        width: isHorizontal ? 150 : double.infinity,
        margin: EdgeInsets.only(
          right: isHorizontal ? 12 : 0,
          bottom: isHorizontal ? 0 : 12,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  MoviePosterWidget(movie: movie, imageHeight: imageHeight),
                  if (showBookmarkAction)
                    RemoveBookmarkButton(onBookmarkRemoved: onBookmarkRemoved),
                ],
              ),
              MovieInfo(movie: movie, showBookmarkAction: showBookmarkAction),
            ],
          ),
        ),
      ),
    );
  }
}
