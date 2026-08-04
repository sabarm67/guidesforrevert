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

    // No saved preference yet — try the device's real location first, for
    // accurate prayer times with zero setup. Falls back to the first known
    // city, silently, if permission is denied or location services are
    // unavailable (e.g. the user hasn't responded to a browser permission
    // prompt) — this is always an optional enhancement, never required to
    // use the app.
    final detected = await _detectDeviceLocation();
    if (detected != null) {
      await _persist(detected.label, detected.latitude, detected.longitude);
      return detected;
    }

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
    final detected = await _detectDeviceLocation();
    if (detected == null) return false;

    await _persist(detected.label, detected.latitude, detected.longitude);
    state = AsyncData(detected);
    return true;
  }

  /// Shared by [build]'s automatic first-launch attempt and
  /// [useDeviceLocation]'s manual picker action. Returns null on any
  /// failure — disabled location services, denied permission, or an error
  /// from the platform — never throws.
  Future<SelectedLocation?> _detectDeviceLocation() async {
    try {
      // The .timeout() guards against a plugin call that never completes at
      // all (e.g. no method-channel handler registered in a widget test, or
      // a browser permission prompt the user never responds to) — a plain
      // try/catch alone only covers calls that *throw*, not ones that hang.
      return await _attemptDeviceLocation().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Covers a missing platform plugin, a timeout, or a genuine runtime
      // failure — either way, this is always an optional enhancement,
      // never required.
      return null;
    }
  }

  Future<SelectedLocation> _attemptDeviceLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw StateError('Location services disabled');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw StateError('Location permission denied');
    }

    final position = await Geolocator.getCurrentPosition();
    return SelectedLocation(label: 'My location', latitude: position.latitude, longitude: position.longitude);
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
