class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  bool isFavorite;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isFavorite = false,
  });
}