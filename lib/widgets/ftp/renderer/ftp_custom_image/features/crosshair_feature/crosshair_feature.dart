import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/features/crosshair_feature/crosshair_painter.dart';
import 'package:flutter/material.dart';

import '../../thermal_samples_painter.dart';

class CrosshairFeature extends StatelessWidget {
  const CrosshairFeature({
    super.key,
    required this.samples,
    required this.width,
    required this.height,
  });

  final List<ThermalSample> samples;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return CustomPaint(
        painter: ThermalSamplesPainter(
          samples: samples,
          width: width,
          height: height,
        ),
      );
    }

    var hotIndex = 0;
    var coldIndex = 0;
    for (var i = 1; i < samples.length; i++) {
      if (samples[i].celsius > samples[hotIndex].celsius) hotIndex = i;
      if (samples[i].celsius < samples[coldIndex].celsius) coldIndex = i;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: ThermalSamplesPainter(
            samples: samples,
            width: width,
            height: height,
          ),
        ),
        CustomPaint(
          painter: CrosshairPainter(
            hotPosition: Offset(
              (hotIndex % width) / (width - 1),
              (hotIndex ~/ width) / (height - 1),
            ),
            coldPosition: Offset(
              (coldIndex % width) / (width - 1),
              (coldIndex ~/ width) / (height - 1),
            ),
            hotTemperature: samples[hotIndex].celsius,
            coldTemperature: samples[coldIndex].celsius,
          ),
        ),
      ],
    );
  }
}
