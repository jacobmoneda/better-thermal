import 'dart:typed_data';

import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/feature_dropdown.dart';
import 'features/crosshair_feature/crosshair_feature.dart';
import 'features/line_feature/line_feature.dart';
import './features/pan_zoom_feature.dart';
import './features/thermal_feature.dart';
import './thermal_gradient.dart';
import './thermal_samples_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import '../ftp_image_renderer.dart';

class FtpCustomImage extends FtpImageRenderer {
  const FtpCustomImage({super.key, required this.image});

  final DirectoryEntryFile image;

  @override
  Uint8List getImageJpeg() {
    if (image.width <= 0 || image.height <= 0) {
      throw ArgumentError('Image dimensions must be positive');
    }

    final colors = renderThermalSamples(
      image.samples,
      image.width,
      image.height,
    );
    final output = img.Image(width: image.width, height: image.height);
    for (var index = 0; index < colors.length; index++) {
      final color = colors[index];
      output.setPixelRgb(
        index % image.width,
        index ~/ image.width,
        (color.r * 255).round().clamp(0, 255),
        (color.g * 255).round().clamp(0, 255),
        (color.b * 255).round().clamp(0, 255),
      );
    }

    return Uint8List.fromList(img.encodeJpg(output));
  }

  @override
  Widget build(BuildContext context) => _CustomImageView(image: image);
}

class _CustomImageView extends ConsumerStatefulWidget {
  const _CustomImageView({required this.image});

  final DirectoryEntryFile image;

  @override
  ConsumerState<_CustomImageView> createState() => _CustomImageViewState();
}

class _CustomImageViewState extends ConsumerState<_CustomImageView> {
  // Feature is always set; crosshair is the default.
  ThermalFeature _feature = ThermalFeature.crosshair;

  // Tracks the visible temperature range reported by PanZoomFeature.
  late double _visibleMin;
  late double _visibleMax;

  DirectoryEntryFile get _image => widget.image;

  @override
  void initState() {
    super.initState();
    _visibleMin = _image.temperatureRange.minimum;
    _visibleMax = _image.temperatureRange.maximum;
  }

  Widget _buildCanvas(TemperatureUnit unit) {
    return switch (_feature) {
      ThermalFeature.panZoom => PanZoomFeature(
        samples: _image.samples,
        width: _image.width,
        height: _image.height,
        onVisibleRangeChanged: (min, max) => setState(() {
          _visibleMin = min;
          _visibleMax = max;
        }),
      ),
      ThermalFeature.line => LineFeature(
        samples: _image.samples,
        width: _image.width,
        height: _image.height,
        unit: unit,
      ),
      ThermalFeature.crosshair => CrosshairFeature(
        samples: _image.samples,
        width: _image.width,
        height: _image.height,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(temperatureUnitProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        if (_image.width > 0 && _image.height > 0)
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(4),
            child: _feature == ThermalFeature.line
                ? _buildCanvas(unit)
                : AspectRatio(
                    aspectRatio: _image.width / _image.height,
                    child: _buildCanvas(unit),
                  ),
          )
        else
          const SizedBox.shrink(),
        ThermalGradient(
          minimum: _image.temperatureRange.minimum,
          maximum: _image.temperatureRange.maximum,
          markerMin: _feature == ThermalFeature.panZoom ? _visibleMin : null,
          markerMax: _feature == ThermalFeature.panZoom ? _visibleMax : null,
        ),
        FeatureDropdown(
          value: _feature,
          onChanged: (v) => setState(() {
            _feature = v;
          }),
        ),
      ],
    );
  }
}
