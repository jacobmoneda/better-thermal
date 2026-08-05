import 'dart:typed_data';

import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:better_thermal/widgets/ftp/renderer/custom/thermal_gradient.dart';
import 'package:better_thermal/widgets/ftp/renderer/custom/thermal_samples_painter.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (image.width > 0 && image.height > 0)
          AspectRatio(
            aspectRatio: image.width / image.height,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(4),
              child: CustomPaint(
                painter: ThermalSamplesPainter(
                  samples: image.samples,
                  width: image.width,
                  height: image.height,
                ),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        const SizedBox(height: 8),
        ThermalGradient(
          minimum: image.temperatureRange.minimum,
          maximum: image.temperatureRange.maximum,
        ),
      ],
    );
  }
}
