import 'package:better_thermal/widgets/settings/credits.dart';
import 'package:better_thermal/widgets/settings/device_setting.dart';
import 'package:better_thermal/widgets/settings/temperature_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        children: [DeviceSetting(), TemperatureSetting(), Credits()],
      ),
    );
  }
}
