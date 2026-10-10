/// "3:05", "1:02:03" for long brews.
String formatDuration(Duration d) {
  final negative = d.isNegative;
  d = d.abs();
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  final ss = s.toString().padLeft(2, '0');
  final body = h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$ss' : '$m:$ss';
  return negative ? '-$body' : body;
}

/// Short human form for overviews: "3:30", "12 h".
String formatBrewTime(Duration d) {
  if (d.inHours >= 1 && d.inMinutes % 60 == 0) return '${d.inHours} h';
  return formatDuration(d);
}

/// "15 g", "16.5 g" — whole numbers when close enough.
String formatGrams(double g) {
  final rounded = (g * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? '${rounded.round()} g'
      : '${rounded.toStringAsFixed(1)} g';
}

String formatRatio(double ratio) {
  final rounded = (ratio * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? '1:${rounded.round()}'
      : '1:${rounded.toStringAsFixed(1)}';
}
