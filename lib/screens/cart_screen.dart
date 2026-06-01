import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _swipeDragOffset = 0.0;
  final double _swipeMaxOffset = 180.0;
  bool _isProcessingOrder = false;

  void _handleCouponSubmit(CartProvider cart) {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    final success = cart.applyCoupon(code);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text('Coupon "$code" applied! Saved 20%'),
            ],
          ),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Invalid coupon code! Try "INSTA20"'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _triggerPaymentSuccess(CartProvider cartProvider) async {
    setState(() {
      _isProcessingOrder = true;
    });

    // Start Live order tracking simulation
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.startOrderSimulation();

    // Show a full-screen premium celebration/success overlay
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, anim1, anim2) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '🎉',
                      style: TextStyle(fontSize: 54),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Payment processed successfully.\nYour fresh products are being picked.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Clear the cart now that it is paid
                    cartProvider.clearCart();
                    Navigator.of(context).pop(); // dismiss dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const OrderTrackingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'TRACK ORDER',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Basket',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: cart.itemCount == 0
          ? _buildEmptyState(context)
          : Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 140),
                  child: Column(
                    children: [
                      // Alert Banner for Coupon advice
                      if (cart.appliedCoupon.isEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryOrange.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text('💡', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Use coupon code "INSTA20" for a flat 20% discount!',
                                  style: TextStyle(
                                    color: AppTheme.primaryOrange,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Grocery Cart item rows
                      if (cart.hasGroceryItems)
                        Card(
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryGreen.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.shopping_cart_rounded, color: AppTheme.primaryGreen, size: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Grocery Items',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartItems.length,
                                  separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9)),
                                  itemBuilder: (context, index) {
                                    final productId = cartItems.keys.elementAt(index);
                                    final qty = cartItems[productId]!;
                                    final product = CartProvider.catalog.firstWhere((p) => p.id == productId);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              product.emoji,
                                              style: const TextStyle(fontSize: 28),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${product.weight} • ₹${product.discountPrice.toInt()}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppTheme.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryGreen,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove, size: 12, color: Colors.white),
                                                  onPressed: () => cart.removeItem(product.id),
                                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                Text(
                                                  '$qty',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add, size: 12, color: Colors.white),
                                                  onPressed: () => cart.addItem(product.id),
                                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Restaurant Menu Items
                      if (cart.hasMenuItems)
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: cart.hasGroceryItems ? 0 : 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryOrange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.restaurant_rounded, color: AppTheme.primaryOrange, size: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Restaurant Orders',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cart.menuItemQuantities.length,
                                  separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9)),
                                  itemBuilder: (context, index) {
                                    final itemId = cart.menuItemQuantities.keys.elementAt(index);
                                    final qty = cart.menuItemQuantities[itemId]!;
                                    final menuItem = cart.menuItemCatalog[itemId]!;
                                    final shopName = cart.menuItemShopNames[itemId] ?? '';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEF3C7),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              menuItem.emoji,
                                              style: const TextStyle(fontSize: 28),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  menuItem.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '$shopName • ₹${menuItem.discountPrice.toInt()}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppTheme.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryOrange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove, size: 12, color: Colors.white),
                                                  onPressed: () => cart.removeMenuItem(itemId),
                                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                Text(
                                                  '$qty',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add, size: 12, color: Colors.white),
                                                  onPressed: () => cart.addMenuItem(menuItem, shopName),
                                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Promo Code Section
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Apply Coupon Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (cart.appliedCoupon.isEmpty)
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _couponController,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppTheme.textDark,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter coupon code (e.g. INSTA20)',
                                          hintStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: AppTheme.textMuted,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () => _handleCouponSubmit(cart),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryOrange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'APPLY',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Coupon "${cart.appliedCoupon}" applied! Saving 20%!',
                                          style: const TextStyle(
                                            color: AppTheme.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close_rounded, color: AppTheme.primaryGreen, size: 18),
                                        onPressed: () => cart.removeCoupon(),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Billing Summary details
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bill Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildBillRow('Item Subtotal', '₹${cart.subtotal.toInt()}'),
                              if (cart.appliedCoupon.isNotEmpty)
                                _buildBillRow(
                                  'Coupon Discount (20%)',
                                  '-₹${cart.couponDiscountAmount.toInt()}',
                                  isSavings: true,
                                ),
                              _buildBillRow(
                                'Delivery Partner Fee',
                                cart.deliveryFee == 0 ? 'FREE' : '₹${cart.deliveryFee.toInt()}',
                                isGreen: cart.deliveryFee == 0,
                              ),
                              _buildBillRow('Govt Taxes & GST (5%)', '₹${cart.taxAmount.toInt()}'),
                              _buildBillRow('Handling & Packaging Charges', '₹${cart.handlingCharges.toInt()}'),
                              const Divider(color: Color(0xFFF1F5F9), height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Grand Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  Text(
                                    '₹${cart.total.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              // Savings summary alert
                              if (cart.itemTotalSavings > 0 || cart.couponDiscountAmount > 0) ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '🎉 Woohoo! You saved ₹${(cart.itemTotalSavings + cart.couponDiscountAmount).toInt()} on this order!',
                                    style: const TextStyle(
                                      color: AppTheme.primaryGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Interactive Slide to Pay Slider
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: _isProcessingOrder
                        ? const SizedBox(
                            height: 52,
                            child: Center(
                              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Slide area
                              GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    _swipeDragOffset += details.primaryDelta!;
                                    if (_swipeDragOffset < 0) _swipeDragOffset = 0.0;
                                    if (_swipeDragOffset > _swipeMaxOffset) {
                                      _swipeDragOffset = _swipeMaxOffset;
                                    }
                                  });
                                },
                                onHorizontalDragEnd: (details) {
                                  if (_swipeDragOffset >= _swipeMaxOffset) {
                                    _triggerPaymentSuccess(cart);
                                  } else {
                                    setState(() {
                                      _swipeDragOffset = 0.0;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 52,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      // Slide advice text
                                      const Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            'SWIPE TO PLACE ORDER  👉',
                                            style: TextStyle(
                                              color: AppTheme.textMuted,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Dragging indicator capsule
                                      Positioned(
                                        left: _swipeDragOffset + 4,
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: const BoxDecoration(
                                            gradient: AppTheme.primaryOrangeGradient,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🛒',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your basket is empty',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add fresh items to your basket and grab offers!',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'SHOP NOW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String title, String value, {bool isSavings = false, bool isGreen = false}) {
    Color valColor = AppTheme.textDark;
    if (isSavings) valColor = Colors.redAccent;
    if (isGreen) valColor = AppTheme.primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isSavings ? Colors.redAccent : AppTheme.textMuted,
              fontWeight: isSavings ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valColor,
              fontWeight: (isSavings || isGreen) ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
