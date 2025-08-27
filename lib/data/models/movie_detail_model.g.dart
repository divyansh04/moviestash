// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailModelAdapter extends TypeAdapter<MovieDetailModel> {
  @override
  final int typeId = 1;

  @override
  MovieDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailModel(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String,
      posterPath: fields[3] as String,
      backdropPath: fields[4] as String,
      voteAverage: fields[5] as double,
      releaseDate: fields[6] as String,
      runtime: fields[7] as int,
      genres: (fields[8] as List).cast<GenreModel>(),
      isBookmarked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.voteAverage)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.runtime)
      ..writeByte(8)
      ..write(obj.genres)
      ..writeByte(9)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenreModelAdapter extends TypeAdapter<GenreModel> {
  @override
  final int typeId = 2;

  @override
  GenreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenreModel(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GenreModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    MovieDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      backdropPath: json['backdrop_path'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] as String,
      runtime: (json['runtime'] as num).toInt(),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );

Map<String, dynamic> _$MovieDetailModelToJson(MovieDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'vote_average': instance.voteAverage,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'isBookmarked': instance.isBookmarked,
    };

GenreModel _$GenreModelFromJson(Map<String, dynamic> json) => GenreModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GenreModelToJson(GenreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
