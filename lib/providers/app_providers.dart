import 'package:better_thermal/config/devices.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:better_thermal/services/device_preferences.dart';
import 'package:better_thermal/services/ftp_service/ftp_service.dart';
import 'package:better_thermal/services/live_stream_service/live_stream_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.selectedDevice,
    required this.temperatureUnit,
    required this.initialized,
  });

  final UNITDevice selectedDevice;
  final TemperatureUnit temperatureUnit;
  final bool initialized;

  AppSettingsState copyWith({
    UNITDevice? selectedDevice,
    TemperatureUnit? temperatureUnit,
    bool? initialized,
  }) {
    return AppSettingsState(
      selectedDevice: selectedDevice ?? this.selectedDevice,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      initialized: initialized ?? this.initialized,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static final _defaultDevice = UNITDevice.devices[1];

  @override
  AppSettingsState build() {
    final initialState = AppSettingsState(
      selectedDevice: _defaultDevice,
      temperatureUnit: TemperatureUnit.celsius,
      initialized: false,
    );

    _loadSettings();

    return initialState;
  }

  Future<void> _loadSettings() async {
    final results = await Future.wait([
      DevicePreferences.loadSelectedDevice(),
      DevicePreferences.loadTemperatureUnit(),
    ]);

    if (!ref.mounted) return;

    state = state.copyWith(
      selectedDevice: (results[0] as UNITDevice?) ?? _defaultDevice,
      temperatureUnit: results[1] as TemperatureUnit,
      initialized: true,
    );
  }

  Future<void> setSelectedDevice(UNITDevice device) async {
    await DevicePreferences.saveSelectedDevice(device);
    if (!ref.mounted) return;
    state = state.copyWith(selectedDevice: device);
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await DevicePreferences.saveTemperatureUnit(unit);
    if (!ref.mounted) return;
    state = state.copyWith(temperatureUnit: unit);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
      AppSettingsNotifier.new,
    );

final selectedDeviceProvider = Provider<UNITDevice>(
  (ref) => ref.watch(appSettingsProvider).selectedDevice,
);

final temperatureUnitProvider = Provider<TemperatureUnit>(
  (ref) => ref.watch(appSettingsProvider).temperatureUnit,
);

final ftpServiceProvider = Provider<FtpService>((ref) {
  final device = ref.watch(selectedDeviceProvider);
  return FtpService(host: device.ftpHost, port: device.ftpPort);
});

final liveStreamServiceProvider = Provider<LiveStreamService>((ref) {
  final device = ref.watch(selectedDeviceProvider);

  final service = LiveStreamService(
    host: device.serverIp,
    port: device.serverPort,
    width: 400,
    height: 300,
  );

  ref.onDispose(service.disconnect);

  return service;
});
