import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final String shopName;

  const MenuItemCard({
    Key? key,
    required this.item,
    required this.shopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final qty = cart.getMenuItemQuantity(item.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Food Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Veg / Non-Veg badge
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: item.isVeg ? AppTheme.primaryGreen : Colors.redAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isVeg ? AppTheme.primaryGreen : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Star rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: AppTheme.primaryGreen, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price
                Row(
                  children: [
                    Text(
                      '₹${item.discountPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (item.hasDiscount) ...[
                      const SizedBox(width: 6),
                      Text(
                        '₹${item.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.discountPercentage.toInt()}% OFF',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: Emoji + Add button
          Column(
            children: [
              // Emoji avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppTheme.premiumBgGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Add to Cart button / Quantity controls
              if (qty == 0)
                GestureDetector(
                  onTap: () => cart.addMenuItem(item, shopName),
                  child: Container(
                    width: 90,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryGreen, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'ADD',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => cart.removeMenuItem(item.id),
                        child: const Icon(Icons.remove, color: Colors.white, size: 16),
                      ),
                      Text(
                        '$qty',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cart.addMenuItem(item, shopName),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
