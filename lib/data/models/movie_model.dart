import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moviestash/domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MovieModel {

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    this.isBookmarked = false,
  });

  factory MovieModel.fromDomain(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      genreIds: movie.genreIds,
      isBookmarked: movie.isBookmarked,
    );
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @HiveField(4)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  @HiveField(6)
  @JsonKey(name: 'release_date')
  final String releaseDate;

  @HiveField(7)
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;

  @HiveField(8)
  final bool isBookmarked;

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toDomain() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      genreIds: genreIds,
      isBookmarked: isBookmarked,
    );
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    List<int>? genreIds,
    bool? isBookmarked,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
@JsonSerializable(explicitToJson: true)
class MoviesResponse {

  const MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);
  final int page;
  final List<MovieModel> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);
}
