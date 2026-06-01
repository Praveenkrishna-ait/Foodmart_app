class MenuItem {
  final String id;
  final String name;
  final double price;
  final double discountPrice;
  final String emoji;
  final String description;
  final String category; // e.g. "Starters", "Main Course", "Desserts", "Drinks"
  final bool isVeg;
  final double rating;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.emoji,
    required this.description,
    required this.category,
    required this.isVeg,
    required this.rating,
  });

  double get discountPercentage {
    if (price <= discountPrice) return 0;
    return ((price - discountPrice) / price) * 100;
  }

  bool get hasDiscount => discountPrice < price;
}
