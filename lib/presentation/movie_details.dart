import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/core/utils.dart';

import '../core/app_style.dart';
import '../core/reusable_widgets/error_widget.dart';
import '../core/services/api_services.dart';
import '../data/movie_model.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  const MovieDetails({super.key, required this.movieId});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieModel?> movieFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieFuture = ApiServices().getMovieById(widget.movieId);
  }

  void fetchMovieDetails() async {
    setState(() {
      movieFuture = ApiServices().getMovieById(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<MovieModel?>(
            future: movieFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 530,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return buildErrorWidget(
                  snapshot.error.toString(),
                  fetchMovieDetails,
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return buildMovieDetails(snapshot.data!, size);
              } else {
                return buildErrorWidget('No data found', fetchMovieDetails);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildMovieDetails(MovieModel movie, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildVideoPlaySection(movie, size),
        buildMovieDetailsSection(movie),
      ],
    );
  }

  Widget buildVideoPlaySection(MovieModel movie, Size size) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                "$BASE_IMAGE_URL${movie.backdropPath}",
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                right: 15,
                child: SizedBox(
                  child: Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.darkGrey,
                        child: Icon(Icons.cast, color: AppColors.white),
                      ),
                      CircleAvatar(
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.darkGrey,
                          ),
                          icon: Icon(Icons.close, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1),
                ),
                child: Icon(Icons.play_arrow_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMovieDetailsSection(MovieModel movie) {
    int hours = (movie.runtime! ~/ 60);
    int minutes = (movie.runtime! % 60);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  softWrap: true,
                  style: movieTitleStyle.copyWith(fontSize: 20),
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text(
                      movie.releaseDate!.year.toString(),
                      style: movieTitleStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text('$hours\h $minutes\m', style: movieTitleStyle),
                  ],
                ),
              ],
            ),
          ),

          actionButtons(
            icon: Icons.play_arrow,
            text: 'Play',
            fgColor: AppColors.black,
            bgColor: AppColors.white,
          ),
          actionButtons(
            icon: Icons.download_sharp,
            text: 'Download',
            fgColor: AppColors.white,
            bgColor: AppColors.grey,
          ),
          Text(movie.overview),
          //action icon buttons
          Row(
            spacing: 50,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Icon(Icons.add, color: AppColors.white, size: 40),
                    Text(
                      'My List',
                      style: movieTitleStyle.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              //Like button
              SizedBox(
                child: Column(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppColors.white,
                      size: 40,
                    ),
                    Text('Rate', style: movieTitleStyle.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      color: AppColors.white,
                      size: 40,
                    ),
                    Text(
                      'My List',
                      style: movieTitleStyle.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle movieTitleStyle = TextStyle(
  color: AppColors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

Widget actionButtons({
  required IconData icon,
  required String text,
  required Color fgColor,
  required Color bgColor,
}) => Container(
  height: 40,
  decoration: BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: fgColor),
      Text(text, style: movieTitleStyle.copyWith(color: fgColor)),
    ],
  ),
);
