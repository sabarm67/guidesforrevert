import 'dart:async';
import 'dart:math' as math;

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import 'location_providers.dart';
import 'qibla_utils.dart';

/// A live, turn-and-point Qibla compass: a Kaaba marker rotates on screen
/// so it always points at the real-world Qibla direction as the phone
/// turns, using the device's magnetometer via [FlutterCompass]. Only
/// Android/iOS phones with a working compass sensor can drive this — on
/// the web, desktop, or a device that never reports a heading, this falls
/// back to a static bearing readout instead (same number already shown in
/// the Prayer tab's Qibla chip, just larger).
class QiblaCompassScreen extends ConsumerStatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  ConsumerState<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends ConsumerState<QiblaCompassScreen> {
  StreamSubscription<CompassEvent>? _subscription;
  Timer? _noSensorTimeout;
  double? _heading;
  bool _liveCompassAvailable = true;

  @override
  void initState() {
    super.initState();
    final events = FlutterCompass.events;
    if (events == null) {
      _liveCompassAvailable = false;
      return;
    }

    // A device can report a non-null events stream yet never actually emit
    // (e.g. no magnetometer hardware) — give it a few seconds to prove
    // itself before falling back to the static readout.
    _noSensorTimeout = Timer(const Duration(seconds: 3), () {
      if (_heading == null && mounted) {
        setState(() => _liveCompassAvailable = false);
      }
    });

    _subscription = events.listen(
      (event) {
        if (!mounted || event.heading == null) return;
        _noSensorTimeout?.cancel();
        setState(() => _heading = event.heading);
      },
      onError: (_) {
        if (mounted) setState(() => _liveCompassAvailable = false);
      },
    );
  }

  @override
  void dispose() {
    _noSensorTimeout?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Compass')),
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not determine location: $err')),
        data: (location) {
          final qiblaBearing = Qibla.qibla(Coordinates(location.latitude, location.longitude));
          final heading = _heading;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(location.label, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Qibla: ${qiblaBearing.round()}° ${compassLabel(qiblaBearing)} from true north',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Center(
                    child: _liveCompassAvailable && heading != null
                        ? _LiveDial(heading: heading, qiblaBearing: qiblaBearing)
                        : _liveCompassAvailable
                        ? const _WaitingForSensor()
                        : _StaticFallback(qiblaBearing: qiblaBearing),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _liveCompassAvailable
                      ? 'Tip: if the arrow seems off, move your phone in a figure-8 to calibrate the compass.'
                      : "This device or browser doesn't report a live compass heading. Face the direction above using a separate compass, or move — the Qibla bearing itself stays accurate.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WaitingForSensor extends StatelessWidget {
  const _WaitingForSensor();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: AppSpacing.md),
        Text('Waiting for compass sensor…'),
      ],
    );
  }
}

/// The rotating dial shown when a live heading is available. The dial
/// (ring + N/E/S/W labels + Kaaba marker) rotates as one group by
/// `-heading`, so the labels always show true compass directions and the
/// Kaaba marker — fixed within that group at the Qibla's true bearing —
/// ends up pointing the right way in the real world no matter which way
/// the phone is held. A fixed pointer above the dial marks "the direction
/// the top of the phone faces"; when the Kaaba marker lines up with it,
/// the user is facing the Qibla.
class _LiveDial extends StatelessWidget {
  const _LiveDial({required this.heading, required this.qiblaBearing});

  final double heading;
  final double qiblaBearing;

  static const _dialSize = 260.0;
  static const _radius = _dialSize / 2;

  bool get _isFacingQibla {
    final diff = ((qiblaBearing - heading + 540) % 360) - 180;
    return diff.abs() < 8;
  }

  Offset _pointOnCircle(double angleDegrees, double radius) {
    final rad = angleDegrees * math.pi / 180;
    return Offset(radius * math.sin(rad), -radius * math.cos(rad));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.arrow_drop_up, size: 36),
        SizedBox(
          width: _dialSize,
          height: _dialSize,
          child: Transform.rotate(
            angle: -heading * math.pi / 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.outlineVariant, width: 2),
                  ),
                ),
                for (final label in compassPoints.where((p) => p.length == 1))
                  Transform.translate(
                    offset: _pointOnCircle(compassPoints.indexOf(label) * 45, _radius - 20),
                    child: Text(
                      label,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                Transform.translate(
                  offset: _pointOnCircle(qiblaBearing, _radius - 48),
                  child: Icon(
                    Icons.mosque,
                    size: 36,
                    color: _isFacingQibla ? Colors.green : scheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          _isFacingQibla ? 'Facing the Qibla ✓' : 'Heading: ${heading.round()}°',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: _isFacingQibla ? Colors.green : null),
        ),
      ],
    );
  }
}

/// Shown when no live sensor reading is available at all (web, desktop, or
/// a device with no magnetometer) — the same bearing the Qibla chip on the
/// Prayer tab already shows, just as the focal point of this screen.
class _StaticFallback extends StatelessWidget {
  const _StaticFallback({required this.qiblaBearing});

  final double qiblaBearing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: qiblaBearing * math.pi / 180,
          child: const Icon(Icons.mosque, size: 64),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '${qiblaBearing.round()}° ${compassLabel(qiblaBearing)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
