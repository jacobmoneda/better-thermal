import 'package:better_thermal/components/alert.dart';
import 'package:better_thermal/config/devices.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceSetting extends ConsumerStatefulWidget {
  const DeviceSetting({super.key});

  @override
  ConsumerState<DeviceSetting> createState() => _DeviceSettingState();
}

class _DeviceSettingState extends ConsumerState<DeviceSetting> {
  bool _isSaving = false;

  Future<void> _selectDevice(UNITDevice? device) async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (device == null || device == selectedDevice || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(appSettingsProvider.notifier).setSelectedDevice(device);
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
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return Column(
      spacing: 8,
      children: [
        Card(
          child: DropdownButtonFormField<UNITDevice>(
            initialValue: selectedDevice,
            decoration: const InputDecoration(
              labelText: 'Device model',
              border: OutlineInputBorder(),
            ),
            items: UNITDevice.devices
                .map(
                  (device) => DropdownMenuItem<UNITDevice>(
                    value: device,
                    child: Text(device.name),
                  ),
                )
                .toList(),
            onChanged: _isSaving ? null : _selectDevice,
          ),
        ),
        const Alert(
          type: .warning,
          message:
              'Make sure to turn on Wi-Fi on your device and connect to it from your phone. You may also need to disable mobile data on your phone to connect to the device.',
        ),
      ],
    );
  }
}
