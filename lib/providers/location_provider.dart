import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/shop.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  String _currentAddress = 'Detecting location...';
  List<Shop> _nearbyShops = [];
  bool _isLoading = false;
  Position? _currentPosition;
  String? errorMessage;

  String get currentAddress => _currentAddress;
  List<Shop> get nearbyShops => _nearbyShops;
  bool get isLoading => _isLoading;

  // Initialize with fallback mock data immediately so UI isn't empty, 
  // then fetch real data.
  LocationProvider() {
    _nearbyShops = Shop.nearbyShops;
    fetchRealLocationAndPlaces();
  }

  void updateAddressManually(String newAddress) {
    _currentAddress = newAddress;
    notifyListeners();
  }

  Future<void> fetchRealLocationAndPlaces() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Get GPS Position
      _currentPosition = await _locationService.getCurrentPosition();
      
      if (_currentPosition != null) {
        // 2. Get Address string from Position
        _currentAddress = await _locationService.getAddressFromCoordinates(_currentPosition!);
        notifyListeners();

        // 3. Get nearby places from Google Places API
        final fetchedShops = await _locationService.getNearbyPlaces(_currentPosition!);
        if (fetchedShops.isNotEmpty) {
           _nearbyShops = fetchedShops;
        } else {
           errorMessage = "No shops found at your location.";
        }
      } else {
        _currentAddress = 'Location permissions denied. Using default.';
        errorMessage = "Could not get current location.";
      }
    } catch (e) {
      errorMessage = "Error: $e";
      print(errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }
}
