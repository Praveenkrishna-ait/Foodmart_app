import 'dart:async';
import 'package:flutter/material.dart';

enum OrderStatus {
  ordered,
  packed,
  outForDelivery,
  delivered,
}

class OrderProvider with ChangeNotifier {
  OrderStatus _status = OrderStatus.ordered;
  int _etaMinutes = 10;
  Timer? _statusTimer;
  Timer? _etaTimer;

  OrderStatus get status => _status;
  int get etaMinutes => _etaMinutes;

  String get courierName => "Rajesh Kumar";
  double get courierRating => 4.9;
  String get courierPhone => "+91 98765 43210";
  String get courierPhotoEmoji => "🚴";

  String get statusTitle {
    switch (_status) {
      case OrderStatus.ordered:
        return "Order Confirmed";
      case OrderStatus.packed:
        return "Packed & Ready";
      case OrderStatus.outForDelivery:
        return "Out for Delivery";
      case OrderStatus.delivered:
        return "Order Delivered!";
    }
  }

  String get statusSubtitle {
    switch (_status) {
      case OrderStatus.ordered:
        return "Instamart is preparing your basket";
      case OrderStatus.packed:
        return "Courier is picking up your items";
      case OrderStatus.outForDelivery:
        return "Rajesh is speeding your way in 10 mins";
      case OrderStatus.delivered:
        return "Thank you for shopping with Instamart!";
    }
  }

  // Start order simulation when checkout completes
  void startOrderSimulation() {
    _status = OrderStatus.ordered;
    _etaMinutes = 10;
    _statusTimer?.cancel();
    _etaTimer?.cancel();
    notifyListeners();

    // Ticks every 8 seconds to transition states
    int step = 0;
    _statusTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      step++;
      if (step == 1) {
        _status = OrderStatus.packed;
      } else if (step == 2) {
        _status = OrderStatus.outForDelivery;
      } else if (step == 3) {
        _status = OrderStatus.delivered;
        _etaMinutes = 0;
        timer.cancel();
        _etaTimer?.cancel();
      }
      notifyListeners();
    });

    // Ticks every 5 seconds to reduce ETA
    _etaTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_etaMinutes > 1 && _status != OrderStatus.delivered) {
        _etaMinutes--;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _etaTimer?.cancel();
    super.dispose();
  }
}
