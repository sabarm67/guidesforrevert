import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearbyMosque {
  const NearbyMosque({required this.name, required this.latitude, required this.longitude, this.address});

  final String name;
  final double latitude;
  final double longitude;
  final String? address;

  double distanceKmFrom(double lat, double lon) {
    return Geolocator.distanceBetween(lat, lon, latitude, longitude) / 1000;
  }
}

class HalalFoodPlace {
  const HalalFoodPlace({
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final String name;

  /// Human-readable place type derived from its OSM `amenity`/`shop` tag,
  /// e.g. "Restaurant", "Butcher", "Supermarket".
  final String category;
  final double latitude;
  final double longitude;
  final String? address;

  double distanceKmFrom(double lat, double lon) {
    return Geolocator.distanceBetween(lat, lon, latitude, longitude) / 1000;
  }
}

/// Queries OpenStreetMap's public Overpass API for nearby mosques/musallas
/// — a deliberate, clearly-labelled exception to this app's offline-first
/// default, since a live directory of real-world places can't reasonably
/// be bundled for the whole world (see docs/architecture/system-architecture.md).
/// No API key required; this is Overpass's standard public endpoint.
class CommunityRepository {
  static const _endpoint = 'https://overpass-api.de/api/interpreter';

  Future<List<NearbyMosque>> findNearbyMosques({
    required double latitude,
    required double longitude,
    double radiusMeters = 15000,
  }) async {
    final query =
        '[out:json][timeout:25];'
        '('
        'node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);'
        'way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);'
        ');'
        'out center tags;';

    final response = await http
        .post(Uri.parse(_endpoint), body: {'data': query})
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Overpass API returned ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = (decoded['elements'] as List).cast<Map<String, dynamic>>();

    final results = <NearbyMosque>[];
    for (final element in elements) {
      final tags = (element['tags'] as Map<String, dynamic>?) ?? {};
      final name = tags['name'] as String? ?? 'Unnamed mosque';

      final lat = (element['lat'] ?? element['center']?['lat']) as double?;
      final lon = (element['lon'] ?? element['center']?['lon']) as double?;
      if (lat == null || lon == null) continue;

      final addressParts = [
        tags['addr:housenumber'],
        tags['addr:street'],
        tags['addr:city'],
      ].whereType<String>();

      results.add(
        NearbyMosque(
          name: name,
          latitude: lat,
          longitude: lon,
          address: addressParts.isEmpty ? null : addressParts.join(', '),
        ),
      );
    }

    results.sort(
      (a, b) => a.distanceKmFrom(latitude, longitude).compareTo(b.distanceKmFrom(latitude, longitude)),
    );

    return results;
  }

  /// Queries Overpass for anything tagged `diet:halal=yes` — the standard
  /// OSM tag used across restaurants, cafes, fast food, butchers,
  /// supermarkets, and convenience stores alike, so one query covers all
  /// of them rather than enumerating every amenity/shop type separately.
  Future<List<HalalFoodPlace>> findHalalFood({
    required double latitude,
    required double longitude,
    double radiusMeters = 15000,
  }) async {
    final query =
        '[out:json][timeout:25];'
        '('
        'node["diet:halal"="yes"](around:$radiusMeters,$latitude,$longitude);'
        'way["diet:halal"="yes"](around:$radiusMeters,$latitude,$longitude);'
        ');'
        'out center tags;';

    final response = await http
        .post(Uri.parse(_endpoint), body: {'data': query})
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Overpass API returned ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = (decoded['elements'] as List).cast<Map<String, dynamic>>();

    final results = <HalalFoodPlace>[];
    for (final element in elements) {
      final tags = (element['tags'] as Map<String, dynamic>?) ?? {};
      final name = tags['name'] as String? ?? 'Unnamed';

      final lat = (element['lat'] ?? element['center']?['lat']) as double?;
      final lon = (element['lon'] ?? element['center']?['lon']) as double?;
      if (lat == null || lon == null) continue;

      final addressParts = [
        tags['addr:housenumber'],
        tags['addr:street'],
        tags['addr:city'],
      ].whereType<String>();

      results.add(
        HalalFoodPlace(
          name: name,
          category: _categoryLabel(tags['amenity'] as String? ?? tags['shop'] as String?),
          latitude: lat,
          longitude: lon,
          address: addressParts.isEmpty ? null : addressParts.join(', '),
        ),
      );
    }

    results.sort(
      (a, b) => a.distanceKmFrom(latitude, longitude).compareTo(b.distanceKmFrom(latitude, longitude)),
    );

    return results;
  }

  String _categoryLabel(String? osmTag) {
    return switch (osmTag) {
      'restaurant' => 'Restaurant',
      'cafe' => 'Cafe',
      'fast_food' => 'Fast Food',
      'butcher' => 'Butcher',
      'supermarket' => 'Supermarket',
      'convenience' => 'Convenience Store',
      'bakery' => 'Bakery',
      null => 'Halal Food',
      _ => osmTag[0].toUpperCase() + osmTag.substring(1).replaceAll('_', ' '),
    };
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) => CommunityRepository());
