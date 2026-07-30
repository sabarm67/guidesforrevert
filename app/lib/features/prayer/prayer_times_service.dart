import 'package:adhan_dart/adhan_dart.dart';

/// Wraps `adhan_dart` — a pure-Dart, offline prayer-time calculation
/// library (no network call) — behind a small app-specific API. See
/// docs/setup/dev-setup.md and the Foundation Package plan for why
/// `adhan_dart` was chosen: identical calculation math on every platform,
/// since it's pure Dart rather than a platform-native plugin.
class DailyPrayerTimes {
  const DailyPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  List<MapEntry<String, DateTime>> get ordered => [
    MapEntry('Fajr', fajr),
    MapEntry('Sunrise', sunrise),
    MapEntry('Dhuhr', dhuhr),
    MapEntry('Asr', asr),
    MapEntry('Maghrib', maghrib),
    MapEntry('Isha', isha),
  ];

  /// The next prayer (or sunrise) after [now], wrapping to Fajr if the day
  /// is over. Sunrise is included since it marks the end of the Fajr
  /// window even though it isn't itself a prayer.
  MapEntry<String, DateTime> next(DateTime now) {
    for (final entry in ordered) {
      if (entry.value.isAfter(now)) return entry;
    }
    return ordered.first;
  }
}

class PrayerTimesService {
  const PrayerTimesService();

  /// KNOWN LIMITATION: results are converted with [DateTime.toLocal], which
  /// uses the *device's* system timezone. That's correct whenever the
  /// device's timezone matches the selected coordinates (the common case —
  /// a Muslim's own phone, at their own location). It becomes wrong if the
  /// selected city (see `location_providers.dart`'s `knownCities`) is in a
  /// different timezone than the device — e.g. testing London prayer
  /// times from a machine set to a Malaysia timezone will show times
  /// shifted by the difference between the two zones. Fixing this
  /// properly needs a coordinates-to-IANA-timezone lookup (e.g. via a
  /// timezone-boundary package) and is noted as future work rather than
  /// solved in the Foundation Package.

  DailyPrayerTimes calculate({required double latitude, required double longitude, DateTime? date}) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethodParameters.muslimWorldLeague();

    final times = PrayerTimes(
      date: date ?? DateTime.now(),
      coordinates: coordinates,
      calculationParameters: params,
    );

    return DailyPrayerTimes(
      fajr: times.fajr.toLocal(),
      sunrise: times.sunrise.toLocal(),
      dhuhr: times.dhuhr.toLocal(),
      asr: times.asr.toLocal(),
      maghrib: times.maghrib.toLocal(),
      isha: times.isha.toLocal(),
    );
  }
}
