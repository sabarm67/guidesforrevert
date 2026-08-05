/// The 8-point compass points, used to turn a raw bearing (degrees from
/// true north) into a readable label like "SE" alongside the number.
const compassPoints = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

String compassLabel(double bearingDegrees) {
  final index = ((bearingDegrees % 360) / 45).round() % 8;
  return compassPoints[index];
}
