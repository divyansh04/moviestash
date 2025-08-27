import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestash/presentation/bloc/search/search_cubit.dart';
import 'package:moviestash/presentation/widgets/movie_list_widget.dart';
import 'package:moviestash/presentation/widgets/shimmer_loading.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(fontSize: 18),
          onChanged:
              (query) => context.read<SearchCubit>().onQueryChanged(query),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Search for movies',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is SearchLoading) {
            return const ShimmerLoading();
          } else if (state is SearchLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_filter, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No movies found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: MovieListWidget(movies: state.movies, isGrid: true),
            );
          } else if (state is SearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
