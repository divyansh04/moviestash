import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {

  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    this.isBookmarked = false,
  });
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<Genre> genres;
  final bool isBookmarked;
  MovieDetail copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    int? runtime,
    List<Genre>? genres,
    bool? isBookmarked,
  }) {
    return MovieDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      runtime: runtime ?? this.runtime,
      genres: genres ?? this.genres,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    releaseDate,
    runtime,
    genres,
    isBookmarked,
  ];
}

class Genre extends Equatable {

  const Genre({required this.id, required this.name});
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
