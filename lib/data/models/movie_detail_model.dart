import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moviestash/domain/entities/movie_detail.dart';

part 'movie_detail_model.g.dart';

@HiveType(typeId: 1) 
@JsonSerializable(explicitToJson: true)
class MovieDetailModel {

  const MovieDetailModel({
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

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  @JsonKey(name: 'poster_path')
  final String posterPath;

  @HiveField(4)
  @JsonKey(name: 'backdrop_path')
  final String backdropPath;

  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  @HiveField(6)
  @JsonKey(name: 'release_date')
  final String releaseDate;

  @HiveField(7)
  final int runtime;

  @HiveField(8)
  final List<GenreModel> genres;

  @HiveField(9)
  final bool isBookmarked;

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);

  MovieDetail toDomain() {
    return MovieDetail(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      runtime: runtime,
      genres: genres.map((g) => Genre(id: g.id, name: g.name)).toList(),
      isBookmarked: isBookmarked,
    );
  }

  MovieDetailModel copyWith({
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    int? runtime,
    List<GenreModel>? genres,
    bool? isBookmarked,
  }) {
    return MovieDetailModel(
      id: id,
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
}

@HiveType(typeId: 2)
@JsonSerializable()
class GenreModel {

  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);
}
