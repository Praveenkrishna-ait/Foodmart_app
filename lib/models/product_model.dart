class Product {
  final String id;
  final String name;
  final double price;
  final double discountPrice;
  final String emoji; // We use gorgeous high-resolution emojis for product visuals
  final String weight;
  final String category;
  final String description;
  final String shelfLife;
  final double rating;
  final int reviewsCount;
  final bool isVeg;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.emoji,
    required this.weight,
    required this.category,
    required this.description,
    required this.shelfLife,
    required this.rating,
    required this.reviewsCount,
    required this.isVeg,
  });

  double get discountPercentage {
    if (price <= discountPrice) return 0;
    return ((price - discountPrice) / price) * 100;
  }

  bool get hasDiscount => discountPrice < price;
}
