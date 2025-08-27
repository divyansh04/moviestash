part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.trendingMovies,
    required this.nowPlayingMovies,
    this.isRefreshing = false,
    this.isLoadingMoreTrending = false,
    this.isLoadingMoreNowPlaying = false,
    this.trendingHasMore = true,
    this.nowPlayingHasMore = true,
  });
  final List<Movie> trendingMovies;
  final List<Movie> nowPlayingMovies;
  final bool isRefreshing;
  final bool isLoadingMoreTrending;
  final bool isLoadingMoreNowPlaying;
  final bool trendingHasMore;
  final bool nowPlayingHasMore;

  HomeLoaded copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? nowPlayingMovies,
    bool? isRefreshing,
    bool? isLoadingMoreTrending,
    bool? isLoadingMoreNowPlaying,
    bool? trendingHasMore,
    bool? nowPlayingHasMore,
  }) {
    return HomeLoaded(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMoreTrending:
          isLoadingMoreTrending ?? this.isLoadingMoreTrending,
      isLoadingMoreNowPlaying:
          isLoadingMoreNowPlaying ?? this.isLoadingMoreNowPlaying,
      trendingHasMore: trendingHasMore ?? this.trendingHasMore,
      nowPlayingHasMore: nowPlayingHasMore ?? this.nowPlayingHasMore,
    );
  }

  @override
  List<Object> get props => [
    trendingMovies,
    nowPlayingMovies,
    isRefreshing,
    isLoadingMoreTrending,
    isLoadingMoreNowPlaying,
    trendingHasMore,
    nowPlayingHasMore,
  ];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
