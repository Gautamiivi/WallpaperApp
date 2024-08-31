class Wallpaper {
  final String id;
  final Src src;

  Wallpaper({required this.id, required this.src});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    // Check for null values and ensure keys exist
    return Wallpaper(
      id: json['id'].toString(), // Ensuring id is treated as a string
      src: Src.fromJson(json['src']),
    );
  }
}

class Src {
  final String portrait;

  Src({required this.portrait});

  factory Src.fromJson(Map<String, dynamic> json) {
    // Check for null and ensure the key 'portrait' exists
    return Src(
      portrait: json['portrait'] ?? '', // Provide a default empty string if null
    );
  }
}
