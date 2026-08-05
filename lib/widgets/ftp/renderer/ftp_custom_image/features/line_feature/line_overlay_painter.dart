import 'package:flutter/material.dart';

class LineOverlayPainter extends CustomPainter {
  const LineOverlayPainter({
    required this.start,
    required this.end,
    required this.startTemperature,
    required this.endTemperature,
  });

  final Offset start;
  final Offset end;
  final double startTemperature;
  final double endTemperature;

  static const _startColor = Color(0xFF66FF66);
  static const _endColor = Color(0xFFFFFF44);

  @override
  void paint(Canvas canvas, Size size) {
    final startPx = Offset(start.dx * size.width, start.dy * size.height);
    final endPx = Offset(end.dx * size.width, end.dy * size.height);

    canvas.drawLine(
      startPx,
      endPx,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    _drawEndpoint(canvas, size, startPx, startTemperature, _startColor);
    _drawEndpoint(canvas, size, endPx, endTemperature, _endColor);
  }

  void _drawEndpoint(
    Canvas canvas,
    Size size,
    Offset point,
    double temperature,
    Color color,
  ) {
    canvas.drawCircle(
      point,
      5,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      point,
      5,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    final label = '${temperature.toStringAsFixed(1)}°';
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(color: Colors.black, blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double labelX = point.dx + 8;
    double labelY = point.dy - textPainter.height / 2;

    if (labelX + textPainter.width > size.width) {
      labelX = point.dx - 8 - textPainter.width;
    }

    labelY = labelY.clamp(0.0, size.height - textPainter.height);
    textPainter.paint(canvas, Offset(labelX, labelY));
  }

  @override
  bool shouldRepaint(covariant LineOverlayPainter oldDelegate) =>
      oldDelegate.start != start ||
      oldDelegate.end != end ||
      oldDelegate.startTemperature != startTemperature ||
      oldDelegate.endTemperature != endTemperature;
}
