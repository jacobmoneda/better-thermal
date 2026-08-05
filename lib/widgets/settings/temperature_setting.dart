import 'package:better_thermal/components/alert.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemperatureSetting extends ConsumerStatefulWidget {
  const TemperatureSetting({super.key});

  @override
  ConsumerState<TemperatureSetting> createState() => _TemperatureSettingState();
}

class _TemperatureSettingState extends ConsumerState<TemperatureSetting> {
  bool _isSaving = false;

  Future<void> _selectTemperatureUnit(TemperatureUnit? unit) async {
    final temperatureUnit = ref.read(temperatureUnitProvider);
    if (unit == null || unit == temperatureUnit || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(appSettingsProvider.notifier).setTemperatureUnit(unit);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);

    return Column(
      spacing: 8,
      children: [
        Card(
          child: DropdownButtonFormField<TemperatureUnit>(
            initialValue: temperatureUnit,
            decoration: const InputDecoration(
              labelText: 'Temperature unit',
              border: OutlineInputBorder(),
            ),
            items: TemperatureUnit.values
                .map(
                  (unit) => DropdownMenuItem<TemperatureUnit>(
                    value: unit,
                    child: Text('${unit.label} (${unit.symbol})'),
                  ),
                )
                .toList(),
            onChanged: _isSaving ? null : _selectTemperatureUnit,
          ),
        ),
        const Alert(
          type: .warning,
          message:
              'This only affects the representation of the temperature in the app. The device will still measure in what has been configured on the device itself.',
        ),
      ],
    );
  }
}
