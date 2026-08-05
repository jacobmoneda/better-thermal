import 'package:better_thermal/widgets/ftp/renderer/ftp_custom_image/features/thermal_feature.dart';
import 'package:flutter/material.dart';

class FeatureDropdown extends StatelessWidget {
  const FeatureDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ThermalFeature value;
  final void Function(ThermalFeature) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ThermalFeature>(
      value: value,
      isExpanded: true,
      items: [
        for (final f in ThermalFeature.values)
          DropdownMenuItem(value: f, child: Text(f.label)),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
