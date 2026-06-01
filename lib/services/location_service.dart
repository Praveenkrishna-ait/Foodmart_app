import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/shop.dart';

class LocationService {
  /// Check permissions and get the current position.
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Get human-readable address from coordinates using Google Geocoding API.
  Future<String> getAddressFromCoordinates(Position position) async {
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      return "Lat: ${position.latitude.toStringAsFixed(2)}, Lng: ${position.longitude.toStringAsFixed(2)}";
    }

    try {
      String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
      
      if (kIsWeb) {
        apiUrl = 'https://corsproxy.io/?${Uri.encodeComponent(apiUrl)}';
      }

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Get the most relevant formatted address or build a short one
          final addressComponents = data['results'][0]['address_components'] as List;
          
          String locality = '';
          String subLocality = '';
          
          for (var component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('sublocality') || types.contains('neighborhood')) {
              subLocality = component['long_name'];
            }
            if (types.contains('locality')) {
              locality = component['long_name'];
            }
          }
          
          String shortAddress = '';
          if (subLocality.isNotEmpty && locality.isNotEmpty) {
            shortAddress = '$subLocality, $locality';
          } else if (locality.isNotEmpty) {
            shortAddress = locality;
          } else {
            shortAddress = data['results'][0]['formatted_address'];
          }
          
          return shortAddress;
        }
      }
    } catch (e) {
      print("Error in Google Geocoding API: $e");
    }
    
    // Fallback if HTTP Geocoding fails
    return "Lat: ${position.latitude.toStringAsFixed(2)}, Lng: ${position.longitude.toStringAsFixed(2)}";
  }

  /// Fetch nearby places using Google Places API (New)
  Future<List<Shop>> getNearbyPlaces(Position position, {String type = 'restaurant'}) async {
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
    
    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      print("Google Places API Key is missing or invalid. Returning mock data.");
      return Shop.nearbyShops; // Fallback to mock data
    }

    // Using Google Places API (New) Nearby Search (POST request)
    String apiUrl = 'https://places.googleapis.com/v1/places:searchNearby';
    
    // Route through a proxy that supports POST requests if on web to bypass CORS
    if (kIsWeb) {
      apiUrl = 'https://corsproxy.io/?${Uri.encodeComponent(apiUrl)}';
    }
    
    final url = Uri.parse(apiUrl);

    final requestBody = json.encode({
      "includedTypes": [type],
      "maxResultCount": 10,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": position.latitude,
            "longitude": position.longitude
          },
          "radius": 2000.0
        }
      }
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'places.displayName,places.rating,places.userRatingCount,places.types,places.id',
        },
        body: requestBody,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final List results = data['places'] ?? [];
        if (results.isNotEmpty) {
          return results.map<Shop>((place) {
            final double rating = (place['rating'] ?? 0.0).toDouble();
            final int reviewsCount = place['userRatingCount'] ?? 0;
            
            final List<String> types = List<String>.from(place['types'] ?? []);
            final List<String> tags = types.isNotEmpty 
                ? [types[0].replaceAll('_', ' ')]
                : ['Shop'];

            return Shop(
              id: place['id'] ?? '',
              name: place['displayName']?['text'] ?? 'Unknown Place',
              imageUrl: '🏪', 
              rating: rating,
              reviewsCount: reviewsCount,
              deliveryTime: '15-30 min',
              distance: 'Nearby',
              tags: tags,
            );
          }).toList();
        }
      } else {
        print("Places API (New) error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception fetching places: $e");
    }
    
    // Fallback if API fails
    return Shop.nearbyShops;
  }
}
