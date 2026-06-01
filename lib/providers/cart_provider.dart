import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  // Mock Catalog of Products
  static final List<Product> catalog = [
    Product(
      id: 'p1',
      name: 'Organic Bananas',
      price: 45.0,
      discountPrice: 35.0,
      emoji: '🍌',
      weight: '500 g',
      category: 'Fruits & Veggies',
      description: 'Fresh, organic sweet bananas imported from local organic farms.',
      shelfLife: '3 days',
      rating: 4.8,
      reviewsCount: 142,
      isVeg: true,
    ),
    Product(
      id: 'p2',
      name: 'Fresh Strawberries',
      price: 120.0,
      discountPrice: 99.0,
      emoji: '🍓',
      weight: '200 g',
      category: 'Fruits & Veggies',
      description: 'Sweet, red, juicy strawberries, packed with rich vitamins.',
      shelfLife: '2 days',
      rating: 4.9,
      reviewsCount: 88,
      isVeg: true,
    ),
    Product(
      id: 'p3',
      name: 'Red Onions',
      price: 30.0,
      discountPrice: 24.0,
      emoji: '🧅',
      weight: '1 kg',
      category: 'Fruits & Veggies',
      description: 'Crisp and pungent red onions, essential for every culinary dish.',
      shelfLife: '7 days',
      rating: 4.6,
      reviewsCount: 210,
      isVeg: true,
    ),
    Product(
      id: 'p4',
      name: 'Fresh Whole Milk',
      price: 60.0,
      discountPrice: 56.0,
      emoji: '🥛',
      weight: '1 L',
      category: 'Dairy & Bread',
      description: 'Pasteurized homogenized cow milk with rich fat content.',
      shelfLife: '2 days',
      rating: 4.7,
      reviewsCount: 420,
      isVeg: true,
    ),
    Product(
      id: 'p5',
      name: 'Salted Butter',
      price: 60.0,
      discountPrice: 50.0,
      emoji: '🧈',
      weight: '100 g',
      category: 'Dairy & Bread',
      description: 'Creamy salted butter perfect for morning toasts and baking.',
      shelfLife: '30 days',
      rating: 4.8,
      reviewsCount: 94,
      isVeg: true,
    ),
    Product(
      id: 'p6',
      name: 'Whole Wheat Bread',
      price: 45.0,
      discountPrice: 38.0,
      emoji: '🍞',
      weight: '400 g',
      category: 'Dairy & Bread',
      description: 'Freshly baked brown wheat bread, rich in high dietary fibers.',
      shelfLife: '4 days',
      rating: 4.5,
      reviewsCount: 165,
      isVeg: true,
    ),
    Product(
      id: 'p7',
      name: 'Crunchy Potato Chips',
      price: 25.0,
      discountPrice: 20.0,
      emoji: '🥔',
      weight: '80 g',
      category: 'Snacks & Munchies',
      description: 'Crisp, golden potato chips lightly seasoned with classic sea salt.',
      shelfLife: '90 days',
      rating: 4.4,
      reviewsCount: 312,
      isVeg: true,
    ),
    Product(
      id: 'p8',
      name: 'Dark Chocolate Bar',
      price: 90.0,
      discountPrice: 75.0,
      emoji: '🍫',
      weight: '85 g',
      category: 'Snacks & Munchies',
      description: 'Premium 75% dark cocoa bar, crafted for intense chocolate lovers.',
      shelfLife: '120 days',
      rating: 4.9,
      reviewsCount: 125,
      isVeg: true,
    ),
    Product(
      id: 'p9',
      name: 'Sparkling Lemonade',
      price: 40.0,
      discountPrice: 30.0,
      emoji: '🍋',
      weight: '300 ml',
      category: 'Cold Drinks',
      description: 'Fizzy, refreshing lemon carbonated beverage with real lemon pulp.',
      shelfLife: '60 days',
      rating: 4.6,
      reviewsCount: 84,
      isVeg: true,
    ),
    Product(
      id: 'p10',
      name: 'Pure Orange Juice',
      price: 100.0,
      discountPrice: 85.0,
      emoji: '🍊',
      weight: '1 L',
      category: 'Cold Drinks',
      description: '100% pure squeezed orange juice, no added sugars or preservatives.',
      shelfLife: '5 days',
      rating: 4.7,
      reviewsCount: 153,
      isVeg: true,
    ),
    Product(
      id: 'p11',
      name: 'Spicy Cup Noodles',
      price: 50.0,
      discountPrice: 45.0,
      emoji: '🍜',
      weight: '70 g',
      category: 'Instant Food',
      description: 'Instant ramen noodles in hot spicy broth, ready in 3 minutes.',
      shelfLife: '180 days',
      rating: 4.3,
      reviewsCount: 220,
      isVeg: true,
    ),
    Product(
      id: 'p12',
      name: 'Tomato Ketchup',
      price: 70.0,
      discountPrice: 62.0,
      emoji: '🥫',
      weight: '500 g',
      category: 'Instant Food',
      description: 'Rich tomato ketchup made from hand-picked vine-ripened red tomatoes.',
      shelfLife: '180 days',
      rating: 4.5,
      reviewsCount: 110,
      isVeg: true,
    ),
  ];

  static final List<CategoryModel> categories = [
    CategoryModel(id: 'c1', name: 'Fruits & Veggies', emoji: '🥦', bgColor: Color(0xFFE8F5E9)),
    CategoryModel(id: 'c2', name: 'Dairy & Bread', emoji: '🍞', bgColor: Color(0xFFFFF8E1)),
    CategoryModel(id: 'c3', name: 'Snacks & Munchies', emoji: '🍿', bgColor: Color(0xFFFCE4EC)),
    CategoryModel(id: 'c4', name: 'Cold Drinks', emoji: '🥤', bgColor: Color(0xFFE0F7FA)),
    CategoryModel(id: 'c5', name: 'Instant Food', emoji: '🍜', bgColor: Color(0xFFFFF3E0)),
  ];

  // ─── Grocery Cart State: productId -> quantity ───
  final Map<String, int> _items = {};

  Map<String, int> get items => {..._items};

  // ─── Menu Item Cart State: menuItemId -> quantity ───
  final Map<String, int> _menuItemQuantities = {};
  final Map<String, MenuItem> _menuItemCatalog = {}; // Store added MenuItems for lookup
  final Map<String, String> _menuItemShopNames = {}; // Track which shop each item came from

  Map<String, int> get menuItemQuantities => {..._menuItemQuantities};
  Map<String, MenuItem> get menuItemCatalog => {..._menuItemCatalog};
  Map<String, String> get menuItemShopNames => {..._menuItemShopNames};

  bool get hasMenuItems => _menuItemQuantities.isNotEmpty;
  bool get hasGroceryItems => _items.isNotEmpty;

  // ─── Combined item count ───
  int get itemCount {
    int total = 0;
    _items.forEach((key, val) => total += val);
    _menuItemQuantities.forEach((key, val) => total += val);
    return total;
  }

  // Get quantity of a single product
  int getProductQuantity(String productId) {
    return _items[productId] ?? 0;
  }

  // ─── Menu Item quantity ───
  int getMenuItemQuantity(String menuItemId) {
    return _menuItemQuantities[menuItemId] ?? 0;
  }

  // Add Item
  void addItem(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    } else {
      _items[productId] = 1;
    }
    notifyListeners();
  }

  // Remove / Decrement Item
  void removeItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]! > 1) {
      _items[productId] = _items[productId]! - 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // ─── Add Menu Item ───
  void addMenuItem(MenuItem item, String shopName) {
    _menuItemCatalog[item.id] = item;
    _menuItemShopNames[item.id] = shopName;
    if (_menuItemQuantities.containsKey(item.id)) {
      _menuItemQuantities[item.id] = _menuItemQuantities[item.id]! + 1;
    } else {
      _menuItemQuantities[item.id] = 1;
    }
    notifyListeners();
  }

  // ─── Remove / Decrement Menu Item ───
  void removeMenuItem(String menuItemId) {
    if (!_menuItemQuantities.containsKey(menuItemId)) return;
    if (_menuItemQuantities[menuItemId]! > 1) {
      _menuItemQuantities[menuItemId] = _menuItemQuantities[menuItemId]! - 1;
    } else {
      _menuItemQuantities.remove(menuItemId);
      _menuItemCatalog.remove(menuItemId);
      _menuItemShopNames.remove(menuItemId);
    }
    notifyListeners();
  }

  // Clear single product fully
  void clearProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Clear Cart
  void clearCart() {
    _items.clear();
    _menuItemQuantities.clear();
    _menuItemCatalog.clear();
    _menuItemShopNames.clear();
    _appliedCoupon = '';
    notifyListeners();
  }

  // Coupon Logic
  String _appliedCoupon = '';
  String get appliedCoupon => _appliedCoupon;

  bool applyCoupon(String couponCode) {
    if (couponCode.toUpperCase() == 'INSTA20' && subtotal > 0) {
      _appliedCoupon = 'INSTA20';
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = '';
    notifyListeners();
  }

  // ─── Bill Calculations (Combined) ───
  double get grocerySubtotal {
    double total = 0.0;
    _items.forEach((productId, qty) {
      final product = catalog.firstWhere((p) => p.id == productId);
      total += product.discountPrice * qty;
    });
    return total;
  }

  double get menuItemSubtotal {
    double total = 0.0;
    _menuItemQuantities.forEach((itemId, qty) {
      final item = _menuItemCatalog[itemId];
      if (item != null) {
        total += item.discountPrice * qty;
      }
    });
    return total;
  }

  double get subtotal => grocerySubtotal + menuItemSubtotal;

  double get couponDiscountAmount {
    if (_appliedCoupon == 'INSTA20') {
      return subtotal * 0.20;
    }
    return 0.0;
  }

  double get itemTotalSavings {
    double savings = 0.0;
    _items.forEach((productId, qty) {
      final product = catalog.firstWhere((p) => p.id == productId);
      if (product.hasDiscount) {
        savings += (product.price - product.discountPrice) * qty;
      }
    });
    _menuItemQuantities.forEach((itemId, qty) {
      final item = _menuItemCatalog[itemId];
      if (item != null && item.hasDiscount) {
        savings += (item.price - item.discountPrice) * qty;
      }
    });
    return savings;
  }

  double get taxAmount {
    return subtotal * 0.05; // 5% GST
  }

  double get deliveryFee {
    if (subtotal == 0) return 0.0;
    if (subtotal >= 200.0) return 0.0; // Free delivery above 200
    return 25.0;
  }

  double get handlingCharges {
    if (subtotal == 0) return 0.0;
    return 5.0; // Flat packaging & handling charge
  }

  double get total {
    double val = subtotal - couponDiscountAmount + taxAmount + deliveryFee + handlingCharges;
    return val < 0 ? 0 : val;
  }
}
