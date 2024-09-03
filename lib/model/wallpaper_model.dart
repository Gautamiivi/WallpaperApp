class Wallpaper {
  final String id;
  final String photographer;
  final Src src;

  Wallpaper({
    required this.id,         // Ensure this is of type String if the API returns a String
    required this.photographer,
    required this.src,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'].toString(),  // Convert to string if necessary
      photographer: json['photographer'],
      src: Src.fromJson(json['src']),
    );
  }
}

class Src {
  final String original;
  final String portrait;
  final String landscape;

  Src({
    required this.original,
    required this.portrait,
    required this.landscape,
  });

  factory Src.fromJson(Map<String, dynamic> json) {
    return Src(
      original: json['original'],
      portrait: json['portrait'],
      landscape: json['landscape'],
    );
  }
}
