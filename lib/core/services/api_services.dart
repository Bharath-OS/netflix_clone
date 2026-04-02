import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:movflix/core/utils.dart';
import 'package:http/http.dart' as http;
import 'package:movflix/data/movie.dart';
import 'package:movflix/data/movie_model.dart';

class ApiServices {
  ApiServices();
  final _headers = {
    "accept": "application/json",
    "Authorization": "Bearer $ACCESS_TOKEN",
  };
  Future<Movies?> getNowPlayingMovies() async {
    final apiURL = Uri.parse("$BASE_URL/movie/now_playing?api_key=$API_KEY");

    try {
      http.Response response = await http.get(
        apiURL,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $ACCESS_TOKEN",
        },
      );
      if (response.statusCode == 200) {
        return moviesFromJson(response.body);
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

  Future<List<MovieModel>?> getUpcomingMovies() async {
    final endpoint = "/movie/upcoming";
    final apiURL = Uri.parse("$BASE_URL$endpoint?language=en-US&page=1");

    try {
      http.Response response = await http.get(apiURL, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['results'] as List;
        final movies = data.map((movie) => MovieModel.fromJson(movie)).toList();
        return movies;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

  Future<List<MovieModel>?> getPopularMovies() async {
    final endpoint = "/movie/popular";
    final apiURL = Uri.parse("$BASE_URL$endpoint?language=en-US&page=1");

    try {
      http.Response response = await http.get(apiURL, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['results'] as List;
        final movies = data.map((movie) => MovieModel.fromJson(movie)).toList();
        return movies;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

  Future<MovieModel?> getMovieById(int movieId) async {
    final endpoint = "/movie/$movieId";
    final apiURL = Uri.parse("$BASE_URL$endpoint?language=en-US");

    try {
      http.Response response = await http.get(apiURL, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return MovieModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
    return null;
  }

  Future<List<MovieModel>?> getMovieRecommendations(int movieId) async {
    final endpoint = "/movie/$movieId/recommendations";
    final apiURL = Uri.parse("$BASE_URL$endpoint?language=en-US&page=1");

    try {
      http.Response response = await http.get(apiURL, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['results'] as List;
        final movies = data.map((movie) => MovieModel.fromJson(movie)).toList();
        return movies;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }
}
