import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/features/community/place_map.dart';

void main() {
  testWidgets('renders with multiple pins spread around the user location', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PlaceMap(
            userLatitude: 51.5074,
            userLongitude: -0.1278,
            pins: [
              PlaceMapPin(latitude: 51.51, longitude: -0.12, label: 'A'),
              PlaceMapPin(latitude: 51.50, longitude: -0.13, label: 'B'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(PlaceMap), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders with no pins (bounds collapse to a single point)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PlaceMap(userLatitude: 51.5074, userLongitude: -0.1278, pins: []),
        ),
      ),
    );

    expect(find.byType(PlaceMap), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
