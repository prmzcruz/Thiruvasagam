class Lyrics {
  final int id;
  final List<LyricLine> lyrics;
  final int id1;
  final List<LyricLine> lyrics1;

  Lyrics({
    required this.id,
    required this.lyrics,
    required this.id1,
    required this.lyrics1,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      id: json['id'] ?? 0,
      lyrics: (json['lyrics'] as List).map((e) => LyricLine.fromJson(e)).toList(),
      id1: json['id'] ?? 1, // Adjust based on your actual JSON structure
      lyrics1: (json['lyrics1'] as List).map((e) => LyricLine.fromJson(e)).toList(),
    );
  }
}

class LyricLine {
  final String timestamp;
  final String line;

  LyricLine({required this.timestamp, required this.line});

  factory LyricLine.fromJson(Map<String, dynamic> json) {
    return LyricLine(
      timestamp: json['timestamp'] ?? '',
      line: json['line'] ?? '',
    );
  }
}