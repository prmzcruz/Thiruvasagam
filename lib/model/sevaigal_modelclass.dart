class CategoryResponse {
  final String message;
  final List<Category> categories;

  CategoryResponse({required this.message, required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      message: json['message'] ?? '',
      categories: (json['categories'] as List<dynamic>?)
          ?.map((x) => Category.fromJson(x))
          .toList() ??
          [],
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
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      fullname: json['fullname'] ?? '',
      catimages: (json['catimages'] as List<dynamic>?)
          ?.map((x) => CatImage.fromJson(x))
          .toList() ??
          [],
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
  final List<CatChild> catChildren;

  CatImage({
    required this.id,
    this.name,
    this.description,
    this.address,
    required this.imageName,
    required this.path,
    required this.catChildren,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'] ?? 0,
      name: json['name'],
      description: json['description'],
      address: json['address'],
      imageName: json['image_name'] ?? '',
      path: json['path'] ?? '',
      catChildren: (json['cat_children'] as List<dynamic>?)
          ?.map((x) => CatChild.fromJson(x))
          .toList() ??
          [],
    );
  }
}

class CatChild {
  final int id;
  final String uuid;
  final String name;
  final String? description;
  final String? address;
  final String imageName;
  final String path;

  CatChild({
    required this.id,
    required this.uuid,
    required this.name,
    this.description,
    this.address,
    required this.imageName,
    required this.path,
  });

  factory CatChild.fromJson(Map<String, dynamic> json) {
    return CatChild(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'],
      imageName: json['image_name'] ?? '',
      path: json['path'] ?? '',
    );
  }
}
