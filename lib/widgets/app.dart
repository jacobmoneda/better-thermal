import 'package:better_thermal/config/devices.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:better_thermal/widgets/ftp/fpt_screen.dart';
import 'package:better_thermal/widgets/live/live_stream.dart';
import 'package:better_thermal/widgets/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNavigationItem {
  final String label;
  final IconData icon;
  final Widget screen;

  const AppNavigationItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  List<AppNavigationItem> _navigationItems() => [
    AppNavigationItem(
      label: 'Live Stream',
      icon: Icons.live_tv,
      screen: const LiveStream(),
    ),
    AppNavigationItem(
      label: 'Saved Images',
      icon: Icons.image,
      screen: const FtpScreen(),
    ),
    AppNavigationItem(
      label: 'Settings',
      icon: Icons.settings,
      screen: const SettingsScreen(),
    ),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    if (!settings.initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final navigationItems = _navigationItems();
    return Scaffold(
      appBar: AppBar(title: Text(navigationItems[currentPageIndex].label)),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: navigationItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
      body: Column(
        children: [
          _DeviceBanner(device: settings.selectedDevice),
          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: navigationItems.map((item) => item.screen).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceBanner extends StatelessWidget {
  final UNITDevice device;

  const _DeviceBanner({required this.device});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SizedBox(
        width: double.infinity,
        height: 32,
        child: Center(
          child: Text(
            'Device: ${device.name}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
