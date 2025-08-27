import 'package:hive/hive.dart';
import 'package:moviestash/data/models/movie_detail_model.dart';
import 'package:moviestash/data/models/movie_model.dart';

abstract class HiveService {
  Future<void> init();
  Future<Box<MovieModel>> openTrendingMoviesBox();
  Future<Box<MovieModel>> openNowPlayingMoviesBox();
  Future<Box<MovieModel>> openBookmarkedMoviesBox();
  Future<Box<MovieDetailModel>> openMovieDetailsBox();
  Future<Box<String>> openSearchCacheBox();
  Future<void> clearAllData();
  Future<void> closeAllBoxes();
}
