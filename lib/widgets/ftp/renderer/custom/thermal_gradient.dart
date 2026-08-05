import 'package:better_thermal/providers/app_providers.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThermalGradient extends ConsumerWidget {
  const ThermalGradient({
    super.key,
    required this.minimum,
    required this.maximum,
  });

  final double? minimum;
  final double? maximum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Container(
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(colors: ThermalColorScale.colors),
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
