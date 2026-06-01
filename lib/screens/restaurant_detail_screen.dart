import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_item_card.dart';
import 'cart_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Shop shop;

  const RestaurantDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    // Default to first menu category
    if (widget.shop.menuCategories.isNotEmpty) {
      _selectedCategory = widget.shop.menuCategories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory.isNotEmpty
        ? widget.shop.getItemsByCategory(_selectedCategory)
        : widget.shop.menuItems;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Hero Header with SliverAppBar ───
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppTheme.textDark,
                      size: 18,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFEF3C7),
                          const Color(0xFFFFEDD5),
                          AppTheme.backgroundLight,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          // Restaurant emoji
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryOrange.withOpacity(0.15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.shop.imageUrl,
                                style: const TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Restaurant Name
                          Text(
                            widget.shop.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Tags
                          Text(
                            widget.shop.tags.join(' • '),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Info chips row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildInfoChip(
                                icon: Icons.star_rounded,
                                label: '${widget.shop.rating}',
                                color: AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 10),
                              _buildInfoChip(
                                icon: Icons.access_time_rounded,
                                label: widget.shop.deliveryTime,
                                color: AppTheme.primaryOrange,
                              ),
                              const SizedBox(width: 10),
                              _buildInfoChip(
                                icon: Icons.location_on_rounded,
                                label: widget.shop.distance,
                                color: const Color(0xFF3B82F6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Menu Category Tabs ───
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryTabDelegate(
                  categories: widget.shop.menuCategories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              ),

              // ─── Menu Items List ───
              if (filteredItems.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No items available in this category.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MenuItemCard(
                          item: filteredItems[index],
                          shopName: widget.shop.name,
                        );
                      },
                      childCount: filteredItems.length,
                    ),
                  ),
                ),
            ],
          ),

          // ─── Floating Cart Bar ───
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
                      // View basket button
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sticky Category Tab Header Delegate ───
class _CategoryTabDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  _CategoryTabDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  bool shouldRebuild(covariant _CategoryTabDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
