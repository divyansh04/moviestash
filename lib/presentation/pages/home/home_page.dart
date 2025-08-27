import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestash/presentation/bloc/home/home_cubit.dart';
import 'package:moviestash/presentation/widgets/movie_list_widget.dart';
import 'package:moviestash/presentation/widgets/shimmer_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _trendingScrollController = ScrollController();
  final _nowPlayingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _trendingScrollController.addListener(() {
      if (_trendingScrollController.position.pixels ==
          _trendingScrollController.position.maxScrollExtent) {
        context.read<HomeCubit>().loadNextTrendingPage();
      }
    });

    _nowPlayingScrollController.addListener(() {
      if (_nowPlayingScrollController.position.pixels ==
          _nowPlayingScrollController.position.maxScrollExtent) {
        context.read<HomeCubit>().loadNextNowPlayingPage();
      }
    });
  }

  @override
  void dispose() {
    _trendingScrollController.dispose();
    _nowPlayingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovieStash',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().refreshMovies(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const ShimmerLoading();
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Trending Now',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MovieListWidget(
                        movies: state.trendingMovies,
                      isHorizontal: true,
                      scrollController: _trendingScrollController,
                      isLoadingMore: state.isLoadingMoreTrending,
                      hasMore: state.trendingHasMore,
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MovieListWidget(
                       movies: state.nowPlayingMovies,
                      isHorizontal: true,
                      scrollController: _nowPlayingScrollController,
                      isLoadingMore: state.isLoadingMoreNowPlaying,
                      hasMore: state.nowPlayingHasMore,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().loadMovies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
