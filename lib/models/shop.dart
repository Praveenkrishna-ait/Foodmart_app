import 'menu_item.dart';

class Shop {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final String distance;
  final List<String> tags;
  final List<MenuItem> menuItems;

  const Shop({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.distance,
    required this.tags,
    this.menuItems = const [],
  });

  /// Get unique menu categories for this shop
  List<String> get menuCategories {
    final cats = menuItems.map((item) => item.category).toSet().toList();
    return cats;
  }

  /// Get menu items filtered by category
  List<MenuItem> getItemsByCategory(String category) {
    return menuItems.where((item) => item.category == category).toList();
  }

  // Mock Data
  static const List<Shop> nearbyShops = [
    Shop(
      id: '1',
      name: 'FreshMart Superstore',
      imageUrl: '🛒',
      rating: 4.8,
      reviewsCount: 1240,
      deliveryTime: '15-20 min',
      distance: '1.2 km',
      tags: ['Groceries', 'Fresh Produce'],
      menuItems: [
        MenuItem(id: 'm1_1', name: 'Farm Fresh Salad Bowl', price: 180, discountPrice: 149, emoji: '🥗', description: 'Crispy greens with cherry tomatoes, cucumbers, and tangy lemon vinaigrette', category: 'Starters', isVeg: true, rating: 4.7),
        MenuItem(id: 'm1_2', name: 'Mushroom Soup', price: 150, discountPrice: 129, emoji: '🍄', description: 'Creamy roasted mushroom soup with garlic croutons', category: 'Starters', isVeg: true, rating: 4.8),
        MenuItem(id: 'm1_3', name: 'Grilled Paneer Wrap', price: 220, discountPrice: 189, emoji: '🌯', description: 'Smoky tandoori paneer wrapped in fresh whole-wheat tortilla', category: 'Main Course', isVeg: true, rating: 4.6),
        MenuItem(id: 'm1_4', name: 'Veggie Pasta Primavera', price: 250, discountPrice: 210, emoji: '🍝', description: 'Penne pasta tossed with seasonal vegetables in creamy alfredo sauce', category: 'Main Course', isVeg: true, rating: 4.9),
        MenuItem(id: 'm1_5', name: 'Quinoa Power Bowl', price: 280, discountPrice: 245, emoji: '🥘', description: 'Protein-packed quinoa with roasted veggies and tahini dressing', category: 'Main Course', isVeg: true, rating: 4.7),
        MenuItem(id: 'm1_6', name: 'Chocolate Lava Cake', price: 180, discountPrice: 159, emoji: '🍫', description: 'Warm molten chocolate cake with a gooey center, served with vanilla ice cream', category: 'Desserts', isVeg: true, rating: 4.9),
        MenuItem(id: 'm1_7', name: 'Mango Smoothie', price: 120, discountPrice: 99, emoji: '🥭', description: 'Thick, creamy Alphonso mango smoothie blended with yogurt', category: 'Drinks', isVeg: true, rating: 4.8),
        MenuItem(id: 'm1_8', name: 'Cold Brew Coffee', price: 150, discountPrice: 130, emoji: '☕', description: 'Slow-steeped cold brew coffee served over ice with caramel drizzle', category: 'Drinks', isVeg: true, rating: 4.6),
      ],
    ),
    Shop(
      id: '2',
      name: 'Green Leaf Organics',
      imageUrl: '🥬',
      rating: 4.9,
      reviewsCount: 856,
      deliveryTime: '25-30 min',
      distance: '2.5 km',
      tags: ['Organic', 'Healthy'],
      menuItems: [
        MenuItem(id: 'm2_1', name: 'Avocado Toast', price: 200, discountPrice: 175, emoji: '🥑', description: 'Smashed avocado on sourdough with chili flakes and microgreens', category: 'Starters', isVeg: true, rating: 4.9),
        MenuItem(id: 'm2_2', name: 'Beetroot Hummus Bowl', price: 160, discountPrice: 140, emoji: '🫕', description: 'Vibrant beetroot hummus with raw veggie dippers and pita chips', category: 'Starters', isVeg: true, rating: 4.7),
        MenuItem(id: 'm2_3', name: 'Buddha Bowl', price: 320, discountPrice: 275, emoji: '🥗', description: 'Organic rice, roasted sweet potato, kale, chickpeas with miso glaze', category: 'Main Course', isVeg: true, rating: 4.9),
        MenuItem(id: 'm2_4', name: 'Tofu Teriyaki Plate', price: 280, discountPrice: 249, emoji: '🍱', description: 'Glazed organic tofu with steamed jasmine rice and stir-fried bok choy', category: 'Main Course', isVeg: true, rating: 4.8),
        MenuItem(id: 'm2_5', name: 'Acai Berry Bowl', price: 250, discountPrice: 220, emoji: '🫐', description: 'Blended acai topped with granola, sliced banana, and chia seeds', category: 'Desserts', isVeg: true, rating: 4.9),
        MenuItem(id: 'm2_6', name: 'Coconut Chia Pudding', price: 180, discountPrice: 160, emoji: '🥥', description: 'Creamy coconut chia pudding layered with tropical fruit compote', category: 'Desserts', isVeg: true, rating: 4.7),
        MenuItem(id: 'm2_7', name: 'Green Detox Juice', price: 140, discountPrice: 120, emoji: '🥒', description: 'Fresh cucumber, celery, spinach, ginger, and green apple juice', category: 'Drinks', isVeg: true, rating: 4.8),
        MenuItem(id: 'm2_8', name: 'Turmeric Golden Latte', price: 130, discountPrice: 110, emoji: '🍵', description: 'Warm oat milk latte infused with turmeric, cinnamon, and honey', category: 'Drinks', isVeg: true, rating: 4.6),
      ],
    ),
    Shop(
      id: '3',
      name: 'Midnight Munchies',
      imageUrl: '🍔',
      rating: 4.5,
      reviewsCount: 342,
      deliveryTime: '10-15 min',
      distance: '0.8 km',
      tags: ['Fast Food', 'Snacks'],
      menuItems: [
        MenuItem(id: 'm3_1', name: 'Loaded Nachos', price: 180, discountPrice: 149, emoji: '🧀', description: 'Crunchy tortilla chips with melted cheese, jalapeños, and salsa', category: 'Starters', isVeg: true, rating: 4.5),
        MenuItem(id: 'm3_2', name: 'Crispy Chicken Wings', price: 250, discountPrice: 210, emoji: '🍗', description: 'Golden fried chicken wings tossed in spicy buffalo sauce', category: 'Starters', isVeg: false, rating: 4.6),
        MenuItem(id: 'm3_3', name: 'Classic Smash Burger', price: 220, discountPrice: 189, emoji: '🍔', description: 'Double-smashed beef patty with cheddar, pickles, and secret sauce', category: 'Main Course', isVeg: false, rating: 4.7),
        MenuItem(id: 'm3_4', name: 'Paneer Tikka Burger', price: 200, discountPrice: 175, emoji: '🍔', description: 'Smoky paneer tikka patty with mint mayo and crunchy slaw', category: 'Main Course', isVeg: true, rating: 4.5),
        MenuItem(id: 'm3_5', name: 'Cheesy Fries', price: 140, discountPrice: 120, emoji: '🍟', description: 'Crispy golden fries loaded with nacho cheese and chives', category: 'Sides', isVeg: true, rating: 4.4),
        MenuItem(id: 'm3_6', name: 'Onion Rings', price: 120, discountPrice: 99, emoji: '🧅', description: 'Beer-battered onion rings with smoky chipotle dip', category: 'Sides', isVeg: true, rating: 4.3),
        MenuItem(id: 'm3_7', name: 'Oreo Milkshake', price: 160, discountPrice: 140, emoji: '🥤', description: 'Thick creamy milkshake loaded with crushed Oreo cookies', category: 'Drinks', isVeg: true, rating: 4.8),
        MenuItem(id: 'm3_8', name: 'Brownie Sundae', price: 180, discountPrice: 155, emoji: '🍨', description: 'Warm fudge brownie topped with vanilla ice cream and hot chocolate', category: 'Desserts', isVeg: true, rating: 4.7),
      ],
    ),
    Shop(
      id: '4',
      name: 'Daily Dairy Center',
      imageUrl: '🥛',
      rating: 4.7,
      reviewsCount: 2100,
      deliveryTime: '15-25 min',
      distance: '1.5 km',
      tags: ['Dairy', 'Essentials'],
      menuItems: [
        MenuItem(id: 'm4_1', name: 'Cheese Garlic Bread', price: 150, discountPrice: 130, emoji: '🧄', description: 'Toasted garlic bread loaded with melted mozzarella and herbs', category: 'Starters', isVeg: true, rating: 4.6),
        MenuItem(id: 'm4_2', name: 'Paneer Butter Masala', price: 260, discountPrice: 220, emoji: '🧈', description: 'Rich creamy tomato gravy with soft paneer cubes and butter', category: 'Main Course', isVeg: true, rating: 4.8),
        MenuItem(id: 'm4_3', name: 'Butter Naan', price: 50, discountPrice: 40, emoji: '🫓', description: 'Soft, fluffy naan brushed with melted butter, baked in tandoor', category: 'Main Course', isVeg: true, rating: 4.7),
        MenuItem(id: 'm4_4', name: 'Curd Rice Bowl', price: 120, discountPrice: 99, emoji: '🍚', description: 'Cooling curd rice tempered with mustard seeds and curry leaves', category: 'Main Course', isVeg: true, rating: 4.5),
        MenuItem(id: 'm4_5', name: 'Rasmalai', price: 140, discountPrice: 120, emoji: '🍮', description: 'Soft cottage cheese discs soaked in saffron-cardamom milk', category: 'Desserts', isVeg: true, rating: 4.9),
        MenuItem(id: 'm4_6', name: 'Gulab Jamun', price: 100, discountPrice: 80, emoji: '🧁', description: 'Golden deep-fried dumplings drenched in rose-flavored sugar syrup', category: 'Desserts', isVeg: true, rating: 4.8),
        MenuItem(id: 'm4_7', name: 'Mango Lassi', price: 90, discountPrice: 75, emoji: '🥭', description: 'Chilled yogurt smoothie blended with sweet Alphonso mango pulp', category: 'Drinks', isVeg: true, rating: 4.7),
        MenuItem(id: 'm4_8', name: 'Rose Milk', price: 70, discountPrice: 60, emoji: '🌹', description: 'Refreshing chilled milk flavored with rose syrup and basil seeds', category: 'Drinks', isVeg: true, rating: 4.5),
      ],
    ),
  ];
}
