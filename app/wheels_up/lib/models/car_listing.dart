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
