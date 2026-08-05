import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:better_thermal/widgets/ftp/renderer/custom/thermal_gradient.dart';
import 'package:flutter/material.dart';

List<Color> renderThermalSamples(
  List<ThermalSample> samples,
  int width,
  int height,
) {
  if (samples.isEmpty || width <= 0 || height <= 0) return const [];

  final count = samples.length < width * height
      ? samples.length
      : width * height;
  var minimum = samples.first.celsius;
  var maximum = minimum;
  for (var index = 1; index < count; index++) {
    final value = samples[index].celsius;
    if (value < minimum) minimum = value;
    if (value > maximum) maximum = value;
  }

  final difference = maximum - minimum;
  return [
    for (var index = 0; index < count; index++)
      _colorForTemperature(samples[index].celsius, minimum, difference),
  ];
}

Color _colorForTemperature(double value, double minimum, double difference) {
  final normalized = difference == 0
      ? 0.5
      : ((value - minimum) / difference).clamp(0.0, 1.0);
  final scaled = normalized * (ThermalColorScale.colors.length - 1);
  final lower = scaled.floor().clamp(0, ThermalColorScale.colors.length - 2);
  return Color.lerp(
    ThermalColorScale.colors[lower],
    ThermalColorScale.colors[lower + 1],
    scaled - lower,
  )!;
}

class ThermalSamplesPainter extends CustomPainter {
  ThermalSamplesPainter({
    required this.samples,
    required this.width,
    required this.height,
  });

  final List<ThermalSample> samples;
  final int width;
  final int height;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = renderThermalSamples(samples, width, height);
    if (colors.isEmpty) return;

    final pixelWidth = size.width / width;
    final pixelHeight = size.height / height;
    final paint = Paint();

    for (var index = 0; index < colors.length; index++) {
      paint.color = colors[index];

      final x = index % width;
      final y = index ~/ width;
      canvas.drawRect(
        Rect.fromLTWH(
          x * pixelWidth,
          y * pixelHeight,
          pixelWidth + 0.5,
          pixelHeight + 0.5,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ThermalSamplesPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
