import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A small hardcoded city lookup, shipped in-app so a location is always
/// available offline without a geocoding service call (a full geocoding
/// integration is future work — see docs/architecture/system-architecture.md).
class KnownCity {
  const KnownCity(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}

const knownCities = [
  KnownCity('London, UK', 51.5072, -0.1276),
  KnownCity('New York, USA', 40.7128, -74.0060),
  KnownCity('Toronto, Canada', 43.6532, -79.3832),
  KnownCity('Kuala Lumpur, Malaysia', 3.1390, 101.6869),
  KnownCity('Jakarta, Indonesia', -6.2088, 106.8456),
  KnownCity('Cairo, Egypt', 30.0444, 31.2357),
  KnownCity('Sydney, Australia', -33.8688, 151.2093),
];

class SelectedLocation {
  const SelectedLocation({required this.label, required this.latitude, required this.longitude});

  final String label;
  final double latitude;
  final double longitude;
}

const _prefsLabelKey = 'prayer_location_label';
const _prefsLatKey = 'prayer_location_lat';
const _prefsLngKey = 'prayer_location_lng';

class LocationController extends AsyncNotifier<SelectedLocation> {
  @override
  Future<SelectedLocation> build() async {
    final prefs = await SharedPreferences.getInstance();
    final label = prefs.getString(_prefsLabelKey);
    final lat = prefs.getDouble(_prefsLatKey);
    final lng = prefs.getDouble(_prefsLngKey);

    if (label != null && lat != null && lng != null) {
      return SelectedLocation(label: label, latitude: lat, longitude: lng);
    }

    // Default to the first known city until the user picks one or grants
    // device location — keeps the Home dashboard's prayer-times card
    // meaningful on first launch with zero setup.
    final defaultCity = knownCities.first;
    return SelectedLocation(
      label: defaultCity.name,
      latitude: defaultCity.latitude,
      longitude: defaultCity.longitude,
    );
  }

  Future<void> selectCity(KnownCity city) async {
    await _persist(city.name, city.latitude, city.longitude);
    state = AsyncData(SelectedLocation(label: city.name, latitude: city.latitude, longitude: city.longitude));
  }

  /// Attempts to use the device's actual location via geolocator. Falls
  /// back silently (leaving the current selection unchanged) if permission
  /// is denied or location services are unavailable — this is always an
  /// optional enhancement, never required to use the app.
  Future<bool> useDeviceLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return false;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      const label = 'My location';
      await _persist(label, position.latitude, position.longitude);
      state = AsyncData(
        SelectedLocation(label: label, latitude: position.latitude, longitude: position.longitude),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _persist(String label, double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLabelKey, label);
    await prefs.setDouble(_prefsLatKey, lat);
    await prefs.setDouble(_prefsLngKey, lng);
  }
}

final locationControllerProvider = AsyncNotifierProvider<LocationController, SelectedLocation>(
  LocationController.new,
);
