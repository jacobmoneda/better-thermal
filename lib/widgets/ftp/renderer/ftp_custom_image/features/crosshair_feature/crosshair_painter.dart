import 'package:flutter/cupertino.dart';

class CrosshairPainter extends CustomPainter {
  const CrosshairPainter({
    required this.hotPosition,
    required this.coldPosition,
    required this.hotTemperature,
    required this.coldTemperature,
  });

  final Offset hotPosition;
  final Offset coldPosition;
  final double hotTemperature;
  final double coldTemperature;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCrosshair(
      canvas,
      size,
      position: hotPosition,
      color: const Color(0xFFFF4444),
      label: 'MAX  ${hotTemperature.toStringAsFixed(1)}°',
    );
    _drawCrosshair(
      canvas,
      size,
      position: coldPosition,
      color: const Color(0xFF44CCFF),
      label: 'MIN  ${coldTemperature.toStringAsFixed(1)}°',
    );
  }

  void _drawCrosshair(
    Canvas canvas,
    Size size, {
    required Offset position,
    required Color color,
    required String label,
  }) {
    final x = position.dx * size.width;
    final y = position.dy * size.height;
    const armLength = 10.0;
    const gapRadius = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw crosshair with a small gap around the centre
    canvas.drawLine(Offset(x - armLength, y), Offset(x - gapRadius, y), paint);
    canvas.drawLine(Offset(x + gapRadius, y), Offset(x + armLength, y), paint);
    canvas.drawLine(Offset(x, y - armLength), Offset(x, y - gapRadius), paint);
    canvas.drawLine(Offset(x, y + gapRadius), Offset(x, y + armLength), paint);

    // Small centre circle
    canvas.drawCircle(
      Offset(x, y),
      gapRadius,
      Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(color: Color(0xFF000000), blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double labelX = x + armLength + 4;
    double labelY = y - textPainter.height / 2;
    if (labelX + textPainter.width > size.width) {
      labelX = x - armLength - 4 - textPainter.width;
    }

    labelY = labelY.clamp(0.0, size.height - textPainter.height);
    textPainter.paint(canvas, Offset(labelX, labelY));
  }

  @override
  bool shouldRepaint(covariant CrosshairPainter oldDelegate) =>
      oldDelegate.hotPosition != hotPosition ||
      oldDelegate.coldPosition != coldPosition ||
      oldDelegate.hotTemperature != hotTemperature ||
      oldDelegate.coldTemperature != coldTemperature;
}
