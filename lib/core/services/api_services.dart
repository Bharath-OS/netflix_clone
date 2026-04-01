import 'package:flutter/cupertino.dart';
import 'package:movflix/core/utils.dart';
import 'package:http/http.dart' as http;
import 'package:movflix/data/movie.dart';

class ApiServices {
  ApiServices();

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
}
