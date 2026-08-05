import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

/// A single pin to render on a [PlaceMap].
class PlaceMapPin {
  const PlaceMapPin({required this.latitude, required this.longitude, required this.label, this.onTap});

  final double latitude;
  final double longitude;
  final String label;
  final VoidCallback? onTap;
}

/// Shared OpenStreetMap view for the Community tab's location-lookup
/// screens (Nearby Mosques, Halal Food Finder). Shows the user's position
/// plus one pin per result, auto-framed to fit them all. Uses raster tiles
/// from OSM's public tile server — the same no-API-key OpenStreetMap
/// infrastructure already relied on for the Overpass lookups themselves.
class PlaceMap extends StatelessWidget {
  const PlaceMap({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.pins,
    this.pinIcon = Icons.place,
    this.height = 220,
  });

  final double userLatitude;
  final double userLongitude;
  final List<PlaceMapPin> pins;
  final IconData pinIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final userPoint = latlong.LatLng(userLatitude, userLongitude);
    final points = [userPoint, ...pins.map((p) => latlong.LatLng(p.latitude, p.longitude))];
    final bounds = LatLngBounds.fromPoints(points);

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.all(40),
                  maxZoom: 16,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.newmuslimcompanion.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userPoint,
                      width: 22,
                      height: 22,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                    for (final pin in pins)
                      Marker(
                        point: latlong.LatLng(pin.latitude, pin.longitude),
                        width: 36,
                        height: 36,
                        child: Tooltip(
                          message: pin.label,
                          child: GestureDetector(
                            onTap: pin.onTap,
                            child: Icon(pinIcon, color: Theme.of(context).colorScheme.error, size: 32),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 4,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: Colors.white70,
                child: const Text('© OpenStreetMap contributors', style: TextStyle(fontSize: 9, color: Colors.black87)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
