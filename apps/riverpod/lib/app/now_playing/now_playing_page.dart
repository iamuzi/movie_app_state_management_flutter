import 'package:core/api/tmdb_api.dart';
import 'package:flutter/material.dart';
import 'package:core/ui/scrollable_movies_page_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app_demo_flutter/app/now_playing/favourite_movies_grid.dart';
import 'package:movie_app_demo_flutter/app/now_playing/now_playing_model.dart';

final moviesModelProvider = StateNotifierProvider<NowPlayingModel>(
    (ref) => NowPlayingModel(api: TMDBClient()));

class NowPlayingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableMoviesPageBuilder(
      title: 'Now Playing',
      onNextPageRequested: () {
        final moviesModel = context.read(moviesModelProvider);
        moviesModel.fetchNextPage();
      },
      builder: (_, controller) {
        return Consumer(
          builder: (context, watch, _) {
            final state = watch(moviesModelProvider.state);
            return state.when(
              data: (movies, _) => FavouritesMovieGrid(
                movies: movies,
                controller: controller,
              ),
              dataLoading: (movies) {
                return movies.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FavouritesMovieGrid(
                        movies: movies,
                        controller: controller,
                      );
              },
              error: (error) => Center(child: Text(error)),
            );
          },
        );
      },
    );
  }
}
