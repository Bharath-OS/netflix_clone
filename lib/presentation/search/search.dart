import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movflix/core/reusable_widgets/error_widget.dart';
import 'package:movflix/core/services/api_services.dart';
import 'package:movflix/core/utils.dart';
import 'package:movflix/presentation/movie_details.dart';

import '../../core/app_style.dart';
import '../../data/movie_model.dart';

class NetflixSearchScreen extends StatefulWidget {
  const NetflixSearchScreen({super.key});

  @override
  State<NetflixSearchScreen> createState() => _NetflixSearchScreenState();
}

class _NetflixSearchScreenState extends State<NetflixSearchScreen> {
  final _searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  late Future<List<MovieModel>?> movies;
  List<MovieModel>? searchResults;

  void search(String query) {
    apiServices.searchMovies(query).then((result) {
      setState(() {
        searchResults = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.background_gradient),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    padding: EdgeInsetsGeometry.all(15),
                    onChanged: (value) {
                      search(value);
                    },
                    placeholder: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: _searchController.text.isEmpty
                      ? SizedBox()
                      : searchResults == null
                      ? SizedBox.shrink()
                      : ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchResults!.length,
                          itemBuilder: (context, index) {
                            final movie = searchResults![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetails(movieId: movie.id),
                                  ),
                                );
                              },
                              child: Container(
                                // Changed SizedBox to Container
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                ), // Added spacing
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Align items to center
                                  children: [
                                    // Give the image a FIXED width container so Row knows the limit
                                    SizedBox(
                                      width: 100,
                                      height: 150,
                                      child: movie.posterPath == null
                                          ? const Center(
                                              child: Icon(
                                                Icons.movie,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${movie.posterPath}',
                                                fit: BoxFit
                                                    .cover, // Use cover to fill the 100x150 area
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Expanded is better than Flexible here to force the text to wrap
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                2, // Ensure it doesn't push the Row height too far
                                          ),
                                          if (movie.releaseDate != null)
                                            Text(
                                              movie.releaseDate!.year
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
