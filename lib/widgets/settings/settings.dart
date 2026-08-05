import 'package:better_thermal/components/alert.dart';
import 'package:better_thermal/config/devices.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _sourceUrl = 'https://github.com/simonwep/better-thermal';
const _sponsorsUrl = 'https://github.com/sponsors/simonwep';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final Future<PackageInfo> _packageInfo;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

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
    final settings = ref.watch(appSettingsProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        children: [
          Card(
            child: DropdownButtonFormField<UNITDevice>(
              initialValue: settings.selectedDevice,
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
          Card(
            child: DropdownButtonFormField<TemperatureUnit>(
              initialValue: settings.temperatureUnit,
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
          Expanded(
            child: Column(
              spacing: 12,
              mainAxisAlignment: .end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontWeight: .bold),
                      children: [
                        const TextSpan(
                          text: 'Build by Simon with ❤️ - consider ',
                        ),
                        TextSpan(
                          text: 'supporting me ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _openUrl(_sponsorsUrl),
                        ),
                        const TextSpan(text: ' if you like this app!'),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: FutureBuilder<PackageInfo>(
                    future: _packageInfo,
                    builder: (context, snapshot) {
                      final buildLabel = snapshot.hasData
                          ? 'Build ${snapshot.data!.version} '
                                '(${snapshot.data!.buildNumber}) · '
                          : 'Build · ';

                      return Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(text: buildLabel),
                            TextSpan(
                              text: 'View on GitHub',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _openUrl(_sourceUrl),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
