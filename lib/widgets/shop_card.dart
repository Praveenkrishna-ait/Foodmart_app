import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../theme/app_theme.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onTap;

  const ShopCard({
    Key? key,
    required this.shop,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image / Emoji Placeholder
            Container(
              height: 110,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: AppTheme.premiumBgGradient,
              ),
              child: Center(
                child: Text(
                  shop.imageUrl,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            
            // Shop Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppTheme.primaryGreen,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              shop.rating.toString(),
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Tags
                  Text(
                    shop.tags.join(' • '),
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Delivery Time & Distance
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppTheme.primaryOrange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.deliveryTime,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppTheme.primaryOrange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.distance,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
