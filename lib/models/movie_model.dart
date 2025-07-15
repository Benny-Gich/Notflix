class Tile {
  String poster;
  String title;
  String imdbID;
  String year;
  String type;

  Tile({
    required this.poster,
    required this.title,
    required this.imdbID,
    required this.type,
    required this.year,
  });

  factory Tile.fromJson(Map<String, dynamic> json) {
    return Tile(
      poster: json["Poster"],
      title: json["Title"],
      imdbID: json["imdbID"],
      type: json["Type"],
      year: json["Year"],
    );
  }
}
