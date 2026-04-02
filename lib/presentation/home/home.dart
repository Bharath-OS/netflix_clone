import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/core/services/api_services.dart';
import 'package:movflix/core/utils.dart';

import '../../core/app_style.dart';
import '../../core/reusable_widgets/error_widget.dart';
import '../../data/movie.dart';
import '../../data/movie_model.dart';
import '../movie_details.dart';

class NetflixHomeScreen extends StatefulWidget {
  const NetflixHomeScreen({super.key});

  @override
  State<NetflixHomeScreen> createState() => _NetflixHomeScreenState();
}

class _NetflixHomeScreenState extends State<NetflixHomeScreen> {
  late Future<Movies?> nowPlayingFuture;
  late Future<List<MovieModel>?> upcomingFuture;
  late Future<List<MovieModel>?> popularFuture;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
  }

  void _fetchPopularMovies() {
    setState(() {
      popularFuture = ApiServices().getPopularMovies();
    });
  }

  void _fetchUpcomingMovies() {
    setState(() {
      upcomingFuture = ApiServices().getUpcomingMovies();
    });
  }

  void _fetchMovies() {
    setState(() {
      nowPlayingFuture = ApiServices().getNowPlayingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.background_gradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/logo/netflix_name.png', height: 50),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search_rounded),
                      ),
                      Icon(Icons.download_sharp),
                      SizedBox(width: 15),
                      Icon(Icons.cast_rounded),
                    ],
                  ),
                  Row(
                    children: [
                      buildTextButton(text: 'Movies'),
                      SizedBox(width: 10),
                      buildTextButton(text: 'TV Shows'),
                      SizedBox(width: 10),
                      buildTextButton(text: 'Categories', isDropDown: true),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FutureBuilder<Movies?>(
                      future: nowPlayingFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 530,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return buildErrorWidget(
                            snapshot.error.toString(),
                            _fetchMovies,
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return buildFeaturedShow(snapshot.data!);
                        } else {
                          return buildErrorWidget(
                            'No data found',
                            _fetchMovies,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  buildMovieTypes(
                    future: upcomingFuture,
                    title: 'Upcoming',
                    onTap: _fetchUpcomingMovies,
                  ),

                  SizedBox(height: 10),
                  buildMovieTypes(
                    future: popularFuture,
                    title: 'Popular Movies',
                    onTap: _fetchPopularMovies,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMovieTypes({
  required Future<List<MovieModel>?> future,
  required String title,
  required VoidCallback onTap,
  bool isReverse = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: buttonTextStyle(AppColors.white)),
      SizedBox(height: 10),
      FutureBuilder<List<MovieModel>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 530,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return buildErrorWidget(snapshot.error.toString(), onTap);
          } else if (snapshot.hasData && snapshot.data != null) {
            return buildMovieTypeListView(snapshot.data!);
          } else {
            return buildErrorWidget('No data found', onTap);
          }
        },
      ),
    ],
  );
}

Widget buildMovieTypeListView(List<MovieModel> movies) {
  return SizedBox(
    height: 180,
    width: double.maxFinite,
    child: ListView.builder(
      reverse: true,
      itemCount: movies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final path = movie.posterPath;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetails(movieId: movie.id),
                ),
              );
            },
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: AppColors.grey, width: 1),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider("$BASE_IMAGE_URL$path"),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget buildFeaturedShow(Movies movies) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SizedBox(
        height: 530,
        width: 388,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PageView.builder(
            itemCount: movies.results.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final movie = movies.results[index];
              final path = movie.posterPath;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetails(movieId: movie.id),
                    ),
                  );
                },
                child: Container(
                  height: 530,
                  width: 388,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.grey, width: 1),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider("$BASE_IMAGE_URL$path"),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      Positioned(
        bottom: -20,
        left: 0,
        right: 0,
        child: buildFeaturedShowInfo(),
      ),
    ],
  );
}

Widget buildFeaturedShowInfo() {
  return SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.play_arrow_rounded, color: AppColors.black),
                SizedBox(width: 5),
                Text('Play', style: buttonTextStyle(AppColors.black)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await ApiServices().getUpcomingMovies();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: AppColors.white),
                  SizedBox(width: 5),
                  Text('My List', style: buttonTextStyle(AppColors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextButton({required String text, bool isDropDown = false}) {
  return TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: AppColors.grey),
    ),
    child: Row(
      children: [Text(text), if (isDropDown) const Icon(Icons.arrow_drop_down)],
    ),
  );
}

TextStyle buttonTextStyle(Color color) =>
    TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500);
