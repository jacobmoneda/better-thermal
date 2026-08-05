import 'package:better_thermal/config/devices.dart';
import 'package:better_thermal/config/temperature_unit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicePreferences {
  static const String _selectedDeviceKey = 'selected_device';
  static const String _temperatureUnitKey = 'temperature_unit';

  static Future<UNITDevice?> loadSelectedDevice() async {
    final preferences = await SharedPreferences.getInstance();
    final selectedName = preferences.getString(_selectedDeviceKey);

    if (selectedName == null) {
      return null;
    }

    return UNITDevice.devices.firstWhere(
      (device) => device.name == selectedName,
    );
  }

  static Future<void> saveSelectedDevice(UNITDevice device) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedDeviceKey, device.name);
  }

  static Future<TemperatureUnit> loadTemperatureUnit() async {
    final preferences = await SharedPreferences.getInstance();
    return TemperatureUnit.fromName(preferences.getString(_temperatureUnitKey));
  }

  static Future<void> saveTemperatureUnit(TemperatureUnit unit) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_temperatureUnitKey, unit.name);
  }
}
