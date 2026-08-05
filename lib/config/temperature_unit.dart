enum TemperatureUnit {
  celsius('celsius', 'Celsius', '°C'),
  fahrenheit('fahrenheit', 'Fahrenheit', '°F'),
  kelvin('kelvin', 'Kelvin', 'K');

  const TemperatureUnit(this.name, this.label, this.symbol);

  final String name;
  final String label;
  final String symbol;

  double fromCelsius(double value) {
    return switch (this) {
      celsius => value,
      fahrenheit => value * 9 / 5 + 32,
      kelvin => value + 273.15,
    };
  }

  String formatCelsius(double value, {int decimals = 1}) {
    return '${fromCelsius(value).toStringAsFixed(decimals)} $symbol';
  }

  static TemperatureUnit fromName(String? name) {
    return TemperatureUnit.values.firstWhere(
      (unit) => unit.name == name,
      orElse: () => TemperatureUnit.celsius,
    );
  }
}
