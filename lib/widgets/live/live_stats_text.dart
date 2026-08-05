import 'package:better_thermal/extensions/file_size_extension.dart';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:better_thermal/services/live_stream_service/live_stream_service.dart';

class LiveStatsText extends ConsumerStatefulWidget {
  const LiveStatsText({super.key});

  @override
  ConsumerState<LiveStatsText> createState() => _LiveStatsTextState();
}

class _LiveStatsTextState extends ConsumerState<LiveStatsText> {
  late LiveStreamStatus _currentStatus;
  double _currentKbps = 0;
  double _currentFps = 0;

  @override
  void initState() {
    super.initState();
    final deviceService = ref.read(liveStreamServiceProvider);
    _currentStatus = deviceService.status;

    deviceService.statusStream.listen((status) {
      setState(() {
        _currentStatus = status;
      });
    });

    deviceService.fpsConnector.listen((fps) {
      setState(() {
        _currentFps = fps;
        _currentKbps = (fps * deviceService.bytesPerFrame * 8) / 1000;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDisconnected = _currentStatus == LiveStreamStatus.disconnected;

    final fpsText = isDisconnected ? 'N/A' : _currentFps.toStringAsFixed(1);
    final kbpsText = isDisconnected
        ? 'N/A'
        : '${_currentKbps.toHumanReadableFileSize()}/s';

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'FPS: $fpsText | Kbps: $kbpsText',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
