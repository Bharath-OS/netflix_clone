import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

class MovieModel {
  bool adult;
  String? backdropPath; // Made optional
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath; // Made optional
  DateTime? releaseDate; // Made optional
  String title;
  int? runtime;
  bool video;
  double voteAverage;
  int voteCount;

  MovieModel({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    this.runtime,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // FIX: Handle both "genre_ids" (from lists) and "genres" (from details)
    List<int> extractedGenreIds = [];
    if (json["genre_ids"] != null) {
      extractedGenreIds = List<int>.from(json["genre_ids"].map((x) => x));
    } else if (json["genres"] != null) {
      extractedGenreIds = List<int>.from(json["genres"].map((x) => x["id"]));
    }

    return MovieModel(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"],
      genreIds: extractedGenreIds,
      id: json["id"] ?? 0,
      originalLanguage: json["original_language"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      popularity: json["popularity"]?.toDouble() ?? 0.0,
      posterPath: json["poster_path"],
      // FIX: Null-safe date parsing
      releaseDate: (json["release_date"] == null || json["release_date"] == "")
          ? null
          : DateTime.tryParse(json["release_date"]),
      title: json["title"] ?? "",
      video: json["video"] ?? false,
      runtime: json["runtime"] ?? 0,
      voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
      voteCount: json["vote_count"] ?? 0,
    );
  }
}
