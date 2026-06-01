import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: AppTheme.textDark, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final qty = cartProvider.getProductQuantity(product.id);

          return Stack(
            children: [
              // Scrollable Details
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large visual container
                    Container(
                      height: 250,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Giant backdrop element
                          Positioned(
                            bottom: -20,
                            child: Opacity(
                              opacity: 0.03,
                              child: Text(
                                product.emoji,
                                style: const TextStyle(fontSize: 220),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'product-image-${product.id}',
                            child: Text(
                              product.emoji,
                              style: const TextStyle(fontSize: 140),
                            ),
                          ),
                          if (product.hasDiscount)
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryOrangeGradient,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  '${product.discountPercentage.toInt()}% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Product basic specs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (product.isVeg) ...[
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green, width: 1.5),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.weight,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹${product.discountPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (product.hasDiscount) ...[
                                Text(
                                  '₹${product.price.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Best Price',
                                    style: TextStyle(
                                      color: AppTheme.primaryOrange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF1F5F9), thickness: 6),

                    // Specification indicators grid row
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSpecItem(Icons.timelapse_rounded, 'Shelf Life', product.shelfLife),
                          _buildSpecItem(Icons.star_rounded, 'Rating', '${product.rating} (${product.reviewsCount} reviews)'),
                          _buildSpecItem(Icons.shield_outlined, '100% Quality', 'Assured'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9), thickness: 6),

                    // About Product Section
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Product',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7), // Light amber
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFCD34D), width: 1),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Important Info',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF92400E),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Please store fresh items in the refrigerator immediately upon delivery to maintain standard freshness.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky floating bottom panel for cart incrementing
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Subtotal indicators
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TOTAL PRICE',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '₹${qty > 0 ? (product.discountPrice * qty).toInt() : product.discountPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Custom incrementer
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.premiumShadow,
                        ),
                        child: qty == 0
                            ? InkWell(
                                onTap: () => cartProvider.addItem(product.id),
                                borderRadius: BorderRadius.circular(16),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'ADD TO BASKET',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white),
                                    onPressed: () => cartProvider.removeItem(product.id),
                                  ),
                                  Text(
                                    '$qty',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    onPressed: () => cartProvider.addItem(product.id),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryOrange, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
