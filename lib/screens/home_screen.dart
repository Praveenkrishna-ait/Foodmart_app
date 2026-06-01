import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/location_header.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import '../models/shop.dart';
import '../widgets/shop_card.dart';
import '../providers/location_provider.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Fruits & Veggies';

  // Beautiful mock banners
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'FRESH VEGGIES',
      'discount': 'UP TO 40% OFF',
      'emoji': '🥦🍓',
      'colors': [Color(0xFF0F9D58), Color(0xFF00C853)],
    },
    {
      'title': 'MIDNIGHT MUNCHIES',
      'discount': 'FREE DELIVERY',
      'emoji': '🍿🍫',
      'colors': [Color(0xFFF97316), Color(0xFFFF8A00)],
    },
    {
      'title': 'DAIRY FRESH',
      'discount': 'EXTRA 15% OFF',
      'emoji': '🥛🧀',
      'colors': [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get catalog products for active category
    final activeProducts = CartProvider.catalog.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Scrollable Content
          Column(
            children: [
              // Sticky Location Header
              const LocationHeader(),
              
              // Remaining Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100), // padding to avoid cart panel overlap
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sticky search bar container
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: CustomSearchBar(readOnly: true),
                      ),

                      // Premium Offer Banner Carousel
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _banners.length,
                          itemBuilder: (context, index) {
                            final banner = _banners[index];
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: banner['colors'],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: AppTheme.premiumShadow,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: Opacity(
                                      opacity: 0.15,
                                      child: Text(
                                        banner['emoji'],
                                        style: const TextStyle(fontSize: 120),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            banner['discount'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          banner['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Delivered in minutes • Grab now!',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Nearby Shops & Food Section
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shops & Food Near You',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                          if (locationProvider.isLoading) {
                            return const SizedBox(
                              height: 220,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            );
                          }

                          if (locationProvider.errorMessage != null) {
                            return SizedBox(
                              height: 220,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    locationProvider.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          if (locationProvider.nearbyShops.isEmpty) {
                            return const SizedBox(
                              height: 220,
                              child: Center(
                                child: Text('No shops found nearby.', style: TextStyle(color: AppTheme.textMuted)),
                              ),
                            );
                          }

                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 16), // right padding handled by card margin
                              itemCount: locationProvider.nearbyShops.length,
                              itemBuilder: (context, index) {
                                final shop = locationProvider.nearbyShops[index];
                                return ShopCard(
                                  shop: shop,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RestaurantDetailScreen(shop: shop),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),

                      // Horizontal Categories Navigation Bar
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Shop by Category',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: CartProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = CartProvider.categories[index];
                            return CategoryItem(
                              category: category,
                              isSelected: _selectedCategory == category.name,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category.name;
                                });
                              },
                            );
                          },
                        ),
                      ),

                      // Category items dynamic grid
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            Text(
                              '${activeProducts.length} items',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Grid View
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: activeProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: activeProducts[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sliding Floating Cart Bottom Sheet Panel
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isCartEmpty = cartProvider.itemCount == 0;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.fastOutSlowIn,
                left: 16,
                right: 16,
                bottom: isCartEmpty ? -80 : 16,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.freshGreenGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.premiumShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cart quantity and total subtotal
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'item' : 'items'} added',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${cartProvider.subtotal.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Swipe or tap button to view cart
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'View Basket',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
