import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/order_provider.dart';
import 'home_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  void _simulatedAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text('Simulating: $action with Rajesh...'),
          ],
        ),
        backgroundColor: AppTheme.primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dynamic delivery countdown panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, Color(0xFF059669)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'ESTIMATED DELIVERY TIME',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      order.status == OrderStatus.delivered ? '00' : '${order.etaMinutes}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'MINS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Quick horizontal progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: _getProgressPercentage(order.status),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    color: Colors.amber,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Timeline details
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // Timeline Cards
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        children: [
                          _buildTimelineStep(
                            context,
                            title: 'Order Placed',
                            subtitle: 'Instamart received and confirmed your basket.',
                            status: _getStepStatus(order.status, OrderStatus.ordered),
                            isFirst: true,
                          ),
                          _buildTimelineStep(
                            context,
                            title: 'Packed & Dispatched',
                            subtitle: 'Your fresh products were carefully packaged and handed over.',
                            status: _getStepStatus(order.status, OrderStatus.packed),
                          ),
                          _buildTimelineStep(
                            context,
                            title: 'Out for Delivery',
                            subtitle: 'Your delivery partner is fast cycling to your flat.',
                            status: _getStepStatus(order.status, OrderStatus.outForDelivery),
                          ),
                          _buildTimelineStep(
                            context,
                            title: 'Delivered',
                            subtitle: 'Basket handed over. Enjoy your fresh groceries!',
                            status: _getStepStatus(order.status, OrderStatus.delivered),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Courier Details Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Courier Avatar
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundLight,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              order.courierPhotoEmoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Profile Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.courierName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${order.courierRating} • Delivery Captain',
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Courier Action buttons
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call_rounded, color: AppTheme.primaryGreen),
                                onPressed: () => _simulatedAction(context, 'Voice Call'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.primaryGreen),
                                onPressed: () => _simulatedAction(context, 'Chat Message'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Navigation Button to exit order tracking screen
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'BACK TO HOME',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getProgressPercentage(OrderStatus status) {
    switch (status) {
      case OrderStatus.ordered:
        return 0.25;
      case OrderStatus.packed:
        return 0.50;
      case OrderStatus.outForDelivery:
        return 0.75;
      case OrderStatus.delivered:
        return 1.0;
    }
  }

  // Helper status checks: -1 is past, 0 is active/current, 1 is future
  int _getStepStatus(OrderStatus currentStatus, OrderStatus step) {
    final curIdx = currentStatus.index;
    final stepIdx = step.index;
    if (curIdx > stepIdx) return -1; // completed/past
    if (curIdx == stepIdx) return 0; // active/current
    return 1; // future/upcoming
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int status, // -1: Done, 0: Active, 1: Upcoming
    bool isFirst = false,
    bool isLast = false,
  }) {
    Color bulletColor = const Color(0xFFCBD5E1);
    Widget bulletWidget = const SizedBox();

    if (status == -1) {
      // Completed step
      bulletColor = AppTheme.primaryGreen;
      bulletWidget = const Icon(Icons.check_rounded, color: Colors.white, size: 14);
    } else if (status == 0) {
      // Active step
      bulletColor = AppTheme.primaryOrange;
      bulletWidget = Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    } else {
      // Future step
      bulletColor = const Color(0xFFE2E8F0);
      bulletWidget = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFFCBD5E1),
          shape: BoxShape.circle,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bullet indicator and connecting line column
          Column(
            children: [
              // Circle bullet point
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                  boxShadow: status == 0
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: bulletWidget,
              ),
              // Connecting line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: status == -1 ? AppTheme.primaryGreen : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Timeline textual description column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: status == 1 ? AppTheme.textMuted : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: status == 1 ? const Color(0xFF94A3B8) : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
