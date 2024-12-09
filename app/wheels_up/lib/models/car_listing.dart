class CarListing {
  final int id;
  final String name;
  final String description;
  final double price;
  final String thumbnail;
  final List<String> features;
  final List<String> requirements;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int posterId;

  CarListing({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.features,
    required this.requirements,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.posterId,
  });

  factory CarListing.fromJson(Map<String, dynamic> json) {

    return CarListing(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      thumbnail: json['thumbnail'],
      features: List<String>.from(json['features']),
      requirements: List<String>.from(json['requirements']),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      posterId: json['posterId'],
    );
  }
}

class CarListing2 {
  final String id;
  final String name;
  final String description;
  final double pricePerHour;
  final String thumbnail;
  final List<String> requirements;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String posterId;

  CarListing2({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.thumbnail,
    required this.requirements,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.posterId,
  });

  factory CarListing2.fromJson(Map<String, dynamic> json) {

    return CarListing2(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      pricePerHour: json['pricePerHour'].toDouble(),
      thumbnail: json['thumbnail'],
      requirements: List<String>.from(json['requirements']),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      posterId: json['posterId'],
    );
  }
}
