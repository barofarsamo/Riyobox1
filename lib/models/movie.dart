class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int? runtime;
  final List<String>? genres;
  final List<String>? cast;
  final String? director;
  final String? contentRating;
  final bool isTvShow;
  final List<Season>? seasons;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    this.voteAverage = 0.0,
    this.runtime,
    this.genres,
    this.cast,
    this.director,
    this.contentRating,
    this.isTvShow = false,
    this.seasons,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      runtime: json['runtime'],
      isTvShow: json['is_tv_show'] ?? false,
    );
  }
}

class Season {
  final int number;
  final String title;
  final List<Episode> episodes;

  Season({required this.number, required this.title, required this.episodes});
}

class Episode {
  final int number;
  final String title;
  final String duration;
  final String? videoUrl;

  Episode({required this.number, required this.title, required this.duration, this.videoUrl});
}
