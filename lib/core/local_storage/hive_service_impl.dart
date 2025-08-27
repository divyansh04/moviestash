// ignore_for_file: strict_raw_type, inference_failure_on_function_invocation

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/local_storage/hive_service.dart';
import 'package:moviestash/data/models/movie_detail_model.dart';
import 'package:moviestash/data/models/movie_model.dart';

@LazySingleton(as: HiveService)
class HiveServiceImpl implements HiveService {
  static const String _trendingMoviesBoxName = 'trending_movies';
  static const String _nowPlayingMoviesBoxName = 'now_playing_movies';
  static const String _bookmarkedMoviesBoxName = 'bookmarked_movies';
  static const String _searchCacheBoxName = 'search_cache';
  static const String _movieDetailsBoxName = 'movie_details';

  bool _isInitialized = false;
  final Map<String, Box> _openBoxes = {};

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      _registerAdapters();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieModelAdapter());
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(MovieDetailModelAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(GenreModelAdapter());
      }
    }
  }

  @override
  Future<Box<MovieDetailModel>> openMovieDetailsBox() async {
    _ensureInitialized();
    return _openBox<MovieDetailModel>(_movieDetailsBoxName);
  }

  @override
  Future<Box<MovieModel>> openTrendingMoviesBox() async {
    _ensureInitialized();
    return _openBox<MovieModel>(_trendingMoviesBoxName);
  }

  @override
  Future<Box<MovieModel>> openNowPlayingMoviesBox() async {
    _ensureInitialized();
    return _openBox<MovieModel>(_nowPlayingMoviesBoxName);
  }

  @override
  Future<Box<MovieModel>> openBookmarkedMoviesBox() async {
    _ensureInitialized();
    return _openBox<MovieModel>(_bookmarkedMoviesBoxName);
  }

  @override
  Future<Box<String>> openSearchCacheBox() async {
    _ensureInitialized();
    return _openBox<String>(_searchCacheBoxName);
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('HiveService must be initialized first');
    }
  }

  Future<Box<T>> _openBox<T>(String boxName) async {
    try {
      if (_openBoxes.containsKey(boxName) && _openBoxes[boxName]!.isOpen) {
        return _openBoxes[boxName]! as Box<T>;
      }

      final box = await Hive.openBox<T>(boxName);
      _openBoxes[boxName] = box;
      return box;
    } catch (e) {
      throw Exception('Failed to open box $boxName: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      for (final boxName in [
        _trendingMoviesBoxName,
        _nowPlayingMoviesBoxName,
        _bookmarkedMoviesBoxName,
        _searchCacheBoxName,
      ]) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).clear();
        }
      }
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  @override
  Future<void> closeAllBoxes() async {
    try {
      for (final box in _openBoxes.values) {
        if (box.isOpen) {
          await box.close();
        }
      }
      _openBoxes.clear();
      await Hive.close();
      _isInitialized = false;
    } catch (e) {
      throw Exception('Failed to close boxes: $e');
    }
  }
}
