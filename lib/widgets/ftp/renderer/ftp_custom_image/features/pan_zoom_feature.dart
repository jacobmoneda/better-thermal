import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:flutter/material.dart';

import '../thermal_samples_painter.dart';

class PanZoomFeature extends StatefulWidget {
  const PanZoomFeature({
    super.key,
    required this.samples,
    required this.width,
    required this.height,
    required this.onVisibleRangeChanged,
  });

  final List<ThermalSample> samples;
  final int width;
  final int height;

  /// Fired on every pan/zoom gesture with the min and max temperature of the
  /// pixels currently visible in the viewport.
  final void Function(double min, double max) onVisibleRangeChanged;

  @override
  State<PanZoomFeature> createState() => _PanZoomFeatureState();
}

class _PanZoomFeatureState extends State<PanZoomFeature> {
  final _controller = TransformationController();
  Size? _viewportSize;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    _updateVisibleRange();
  }

  void _updateVisibleRange() {
    final viewportSize = _viewportSize;
    if (viewportSize == null ||
        viewportSize.width <= 0 ||
        viewportSize.height <= 0) {
      return;
    }

    // The transformation matrix maps child-local coordinates to viewport
    // (scene) coordinates: viewport_pt = M * child_pt.
    // Invert to find which child region is currently visible.
    final inverted = Matrix4.inverted(_controller.value);
    final tl = MatrixUtils.transformPoint(inverted, Offset.zero);
    final br = MatrixUtils.transformPoint(
      inverted,
      Offset(viewportSize.width, viewportSize.height),
    );

    // With constrained: true the child fills the viewport, so child size ==
    // viewportSize.  Map child coordinates to image pixel coordinates.
    final left = (tl.dx / viewportSize.width * widget.width)
        .clamp(0.0, widget.width - 1.0)
        .round();
    final top = (tl.dy / viewportSize.height * widget.height)
        .clamp(0.0, widget.height - 1.0)
        .round();
    final right = (br.dx / viewportSize.width * widget.width)
        .clamp(0.0, widget.width - 1.0)
        .round();
    final bottom = (br.dy / viewportSize.height * widget.height)
        .clamp(0.0, widget.height - 1.0)
        .round();

    var min = double.infinity;
    var max = double.negativeInfinity;
    for (var py = top; py <= bottom; py++) {
      for (var px = left; px <= right; px++) {
        final index = py * widget.width + px;
        if (index >= 0 && index < widget.samples.length) {
          final temp = widget.samples[index].celsius;
          if (temp < min) min = temp;
          if (temp > max) max = temp;
        }
      }
    }

    if (min.isFinite && max.isFinite) {
      widget.onVisibleRangeChanged(min, max);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportSize = constraints.biggest;
        return InteractiveViewer(
          transformationController: _controller,
          minScale: 1.0,
          maxScale: 12.0,
          clipBehavior: Clip.none,
          child: CustomPaint(
            painter: ThermalSamplesPainter(
              samples: widget.samples,
              width: widget.width,
              height: widget.height,
            ),
          ),
        );
      },
    );
  }
}
