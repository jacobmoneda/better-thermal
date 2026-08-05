import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/features/line_feature/line_feature.dart';
import 'package:flutter/material.dart';

class LineInfo extends StatelessWidget {
  const LineInfo({super.key, required this.lineData, required this.unit});

  final LineData? lineData;
  final TemperatureUnit unit;

  /// Formats a temperature *difference* in the user's unit.
  /// A difference does not carry an additive offset (no +32 for °F).
  String _formatDelta(double deltaCelsius) {
    final converted = switch (unit) {
      TemperatureUnit.celsius || TemperatureUnit.kelvin => deltaCelsius,
      TemperatureUnit.fahrenheit => deltaCelsius * 9 / 5,
    };

    return '${converted.toStringAsFixed(1)} ${unit.symbol}';
  }

  @override
  Widget build(BuildContext context) {
    if (lineData == null) {
      return SizedBox(
        height: 54,
        child: Container(
          alignment: .center,
          child: Text(
            'Drag on the image to measure temperatures along a line.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final data = lineData!;
    return SizedBox(
      height: 54,
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          _TempCell(
            label: 'Start',
            value: unit.formatCelsius(data.startTemperature),
          ),
          _TempCell(
            label: 'End',
            value: unit.formatCelsius(data.endTemperature),
          ),
          _TempCell(label: 'Δ', value: _formatDelta(data.deltaCelsius)),
        ],
      ),
    );
  }
}

class _TempCell extends StatelessWidget {
  const _TempCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
