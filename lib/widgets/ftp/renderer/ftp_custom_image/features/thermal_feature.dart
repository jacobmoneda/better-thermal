enum ThermalFeature {
  panZoom('Pan / Zoom'),
  line('Line'),
  crosshair('Crosshair');

  const ThermalFeature(this.label);

  final String label;
}
