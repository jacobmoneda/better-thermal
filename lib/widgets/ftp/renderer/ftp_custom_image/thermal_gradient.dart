import 'package:better_thermal/providers/app_providers.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThermalGradient extends ConsumerWidget {
  const ThermalGradient({
    super.key,
    required this.minimum,
    required this.maximum,
    this.markerMin,
    this.markerMax,
  });

  final double? minimum;
  final double? maximum;

  /// When both are provided the gradient bar shows two labelled tick marks
  /// indicating where these temperatures sit within [minimum]..[maximum].
  final double? markerMin;
  final double? markerMax;

  static const _barHeight = 14.0;
  static const _markerAreaHeight = 18.0; // room for caret + label above bar

  bool get _hasMarkers =>
      markerMin != null &&
      markerMax != null &&
      minimum != null &&
      maximum != null &&
      maximum! > minimum!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final hasMarkers = _hasMarkers;

    double normMin = 0, normMax = 1;
    if (hasMarkers) {
      final range = maximum! - minimum!;
      normMin = ((markerMin! - minimum!) / range).clamp(0.0, 1.0);
      normMax = ((markerMax! - minimum!) / range).clamp(0.0, 1.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        SizedBox(
          height: hasMarkers ? _barHeight + _markerAreaHeight : _barHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gradient bar pinned to the bottom of the SizedBox
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _barHeight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: ThermalColorScale.colors,
                    ),
                  ),
                ),
              ),
              // Marker carets + tick lines drawn over the full height
              if (hasMarkers)
                CustomPaint(
                  painter: _GradientMarkerPainter(
                    normalizedMin: normMin,
                    normalizedMax: normMax,
                    labelMin: _formatTemperature(markerMin, temperatureUnit),
                    labelMax: _formatTemperature(markerMax, temperatureUnit),
                    barHeight: _barHeight,
                  ),
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatTemperature(minimum, temperatureUnit),
              style: textStyle,
            ),
            Text(
              _formatTemperature(maximum, temperatureUnit),
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }

  String _formatTemperature(double? value, TemperatureUnit unit) {
    return value == null ? '--' : unit.formatCelsius(value);
  }
}

class _GradientMarkerPainter extends CustomPainter {
  const _GradientMarkerPainter({
    required this.normalizedMin,
    required this.normalizedMax,
    required this.labelMin,
    required this.labelMax,
    required this.barHeight,
  });

  final double normalizedMin;
  final double normalizedMax;
  final String labelMin;
  final String labelMax;
  final double barHeight;

  static const _labelStyle = TextStyle(
    color: Colors.white,
    fontSize: 9,
    fontWeight: FontWeight.bold,
    shadows: [Shadow(color: Colors.black, blurRadius: 2, offset: Offset(0, 1))],
  );

  @override
  void paint(Canvas canvas, Size size) {
    _drawMarker(canvas, size, normalizedMin, labelMin);
    _drawMarker(canvas, size, normalizedMax, labelMax);
  }

  void _drawMarker(Canvas canvas, Size size, double normalized, String label) {
    final x = (normalized * size.width).clamp(0.0, size.width);
    final barTop = size.height - barHeight;

    canvas.drawLine(
      Offset(x, barTop),
      Offset(x, size.height),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.butt,
    );
    canvas.drawLine(
      Offset(x, barTop),
      Offset(x, size.height),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.butt,
    );

    const halfBase = 4.5;
    const caretHeight = 5.0;
    final caretPath = Path()
      ..moveTo(x - halfBase, barTop - caretHeight)
      ..lineTo(x + halfBase, barTop - caretHeight)
      ..lineTo(x, barTop)
      ..close();
    canvas.drawPath(
      caretPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      caretPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    final tp = TextPainter(
      text: TextSpan(text: label, style: _labelStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final labelY = barTop - caretHeight - tp.height - 1;
    if (labelY < 0) return; // not enough room

    final labelX = (x - tp.width / 2).clamp(0.0, size.width - tp.width);
    tp.paint(canvas, Offset(labelX, labelY));
  }

  @override
  bool shouldRepaint(covariant _GradientMarkerPainter old) =>
      old.normalizedMin != normalizedMin ||
      old.normalizedMax != normalizedMax ||
      old.labelMin != labelMin ||
      old.labelMax != labelMax;
}

class ThermalColorScale {
  const ThermalColorScale._();

  static const colors = [
    Color(0xff000000), // Black (coldest)
    Color(0xff00008b), // Dark blue
    Color(0xff0000ff), // Blue
    Color(0xff00ffff), // Cyan (light blue)
    Color(0xff00ff00), // Green
    Color(0xffffff00), // Yellow
    Color(0xffff7f00), // Orange
    Color(0xffff0000), // Red
    Color(0xffff00ff), // Magenta / Pink
    Color(0xffffffff), // White (hottest)
  ];
}
