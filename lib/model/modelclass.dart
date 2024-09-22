class Location {
  int id;
  String name;
  String audioUrl;
  String videoUrl;
  String thumbnailimg;
  String videoid;
  double latitude;
  double longitude;
  String desc;

  Location({
    required this.id,
    required this.name,
    required this.audioUrl,
    required this.videoUrl,
    required this.thumbnailimg,
    required this.videoid,
    required this.latitude,
    required this.longitude,
    required this.desc,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
      thumbnailimg: json['thumbnailimg'],
      videoid: json['videoid'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      desc: json['Desc'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['audioUrl'] = this.audioUrl;
    data['videoUrl'] = this.videoUrl;
    data['thumbnailimg'] = this.thumbnailimg;
    data['videoid'] = this.videoid;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['Desc'] = this.desc;
    return data;
  }
}
