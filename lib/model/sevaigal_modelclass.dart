// models/category_model.dart

class CategoryResponse {
  final String message;
  final List<Category> user;

  CategoryResponse({required this.message, required this.user});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      message: json['message'],
      user: List<Category>.from(json['user'].map((x) => Category.fromJson(x))),
    );
  }
}

class Category {
  final int id;
  final String uuid;
  final String name;
  final String fullname;
  final List<CatImage> catimages;

  Category({
    required this.id,
    required this.uuid,
    required this.name,
    required this.fullname,
    required this.catimages,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      fullname: json['fullname'],
      catimages: List<CatImage>.from(
          json['catimages'].map((x) => CatImage.fromJson(x))),
    );
  }
}

class CatImage {
  final int id;
  final String? name;
  final String? description;
  final String? address;
  final String imageName;
  final String path;

  CatImage({
    required this.id,
    this.name,
    this.description,
    this.address,
    required this.imageName,
    required this.path,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      imageName: json['image_name'],
      path: json['path'],
    );
  }
}
