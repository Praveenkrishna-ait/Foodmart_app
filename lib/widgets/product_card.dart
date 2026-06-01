import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final qty = cartProvider.getProductQuantity(product.id);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.softShadow,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Product Main Details Layout
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Backdrop
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Hero(
                              tag: 'product-image-${product.id}',
                              child: Text(
                                product.emoji,
                                style: const TextStyle(fontSize: 54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Veg Badge & Rating
                      Row(
                        children: [
                          if (product.isVeg)
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green, width: 1.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Product Name
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Weight
                      Text(
                        product.weight,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                      ),
                      const SizedBox(height: 8),
                      // Price & Add To Cart Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.hasDiscount)
                                Text(
                                  '₹${product.price.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '₹${product.discountPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                          // Custom counter OR Add button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: 34,
                            decoration: BoxDecoration(
                              color: qty > 0 ? AppTheme.primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.primaryGreen,
                                width: 1.5,
                              ),
                              boxShadow: qty > 0 ? AppTheme.softShadow : null,
                            ),
                            child: qty == 0
                                ? InkWell(
                                    onTap: () => cartProvider.addItem(product.id),
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Center(
                                        child: Text(
                                          'ADD',
                                          style: TextStyle(
                                            color: AppTheme.primaryGreen,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                                        onPressed: () => cartProvider.removeItem(product.id),
                                        constraints: const BoxConstraints(minWidth: 26, minHeight: 34),
                                        padding: EdgeInsets.zero,
                                      ),
                                      Text(
                                        '$qty',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 14, color: Colors.white),
                                        onPressed: () => cartProvider.addItem(product.id),
                                        constraints: const BoxConstraints(minWidth: 26, minHeight: 34),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Discount Ribbon Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryOrangeGradient,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        '${product.discountPercentage.toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
