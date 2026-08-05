import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/features/line_feature/line_feature_info.dart';
import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/features/line_feature/line_overlay_painter.dart';
import 'package:flutter/material.dart';

import '../../thermal_samples_painter.dart';

/// Immutable snapshot of a measured line between two image points.
class LineData {
  const LineData({
    required this.startNormalized,
    required this.endNormalized,
    required this.startTemperature,
    required this.endTemperature,
  });

  /// Both offsets are normalised to [0, 1] in both axes.
  final Offset startNormalized;
  final Offset endNormalized;
  final double startTemperature;
  final double endTemperature;

  double get deltaCelsius => (endTemperature - startTemperature).abs();
}

class LineFeature extends StatefulWidget {
  const LineFeature({
    super.key,
    required this.samples,
    required this.width,
    required this.height,
    required this.unit,
  });

  final List<ThermalSample> samples;
  final int width;
  final int height;
  final TemperatureUnit unit;

  @override
  State<LineFeature> createState() => _LineFeatureState();
}

class _LineFeatureState extends State<LineFeature> {
  Offset? _start;
  Offset? _end;

  double _temperatureAt(Offset normalized) {
    final px = (normalized.dx * (widget.width - 1)).round().clamp(
      0,
      widget.width - 1,
    );
    final py = (normalized.dy * (widget.height - 1)).round().clamp(
      0,
      widget.height - 1,
    );
    final index = py * widget.width + px;
    if (index < 0 || index >= widget.samples.length) return 0.0;
    return widget.samples[index].celsius;
  }

  Offset _normalise(Offset local, Size size) => Offset(
    (local.dx / size.width).clamp(0.0, 1.0),
    (local.dy / size.height).clamp(0.0, 1.0),
  );

  void _onPanStart(DragStartDetails details, Size size) {
    final n = _normalise(details.localPosition, size);
    setState(() {
      _start = n;
      _end = n;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final n = _normalise(details.localPosition, size);
    setState(() => _end = n);
  }

  void _onPanCancel() {
    setState(() {
      _start = null;
      _end = null;
    });
  }

  LineData? get _lineData => _start == null || _end == null
      ? null
      : LineData(
          startNormalized: _start!,
          endNormalized: _end!,
          startTemperature: _temperatureAt(_start!),
          endTemperature: _temperatureAt(_end!),
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        AspectRatio(
          aspectRatio: widget.width / widget.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                onPanStart: (d) => _onPanStart(d, size),
                onPanUpdate: (d) => _onPanUpdate(d, size),
                onPanCancel: _onPanCancel,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: ThermalSamplesPainter(
                        samples: widget.samples,
                        width: widget.width,
                        height: widget.height,
                      ),
                    ),
                    if (_start != null && _end != null)
                      CustomPaint(
                        painter: LineOverlayPainter(
                          start: _start!,
                          end: _end!,
                          startTemperature: _temperatureAt(_start!),
                          endTemperature: _temperatureAt(_end!),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        LineInfo(lineData: _lineData, unit: widget.unit),
      ],
    );
  }
}
