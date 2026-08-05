import 'dart:async';
import 'package:better_thermal/providers/app_providers.dart';
import 'package:better_thermal/services/live_stream_service/live_stream_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class LiveImageCanvas extends ConsumerStatefulWidget {
  const LiveImageCanvas({super.key});

  @override
  LiveImageCanvasState createState() => LiveImageCanvasState();
}

class LiveImageCanvasState extends ConsumerState<LiveImageCanvas> {
  ui.Image? _latestFrame;
  Uint8List? _latestFrameBytes;
  StreamSubscription<Uint8List>? _frameSubscription;

  @override
  void initState() {
    super.initState();
    _subscribe(ref.read(liveStreamServiceProvider));
    ref.listenManual(liveStreamServiceProvider, (_, service) {
      _frameSubscription?.cancel();
      _latestFrame?.dispose();
      _latestFrame = null;
      _latestFrameBytes = null;
      _subscribe(service);
    });
  }

  void _subscribe(LiveStreamService service) {
    _frameSubscription = service.frameStream.listen((Uint8List rgbaFrame) {
      _decodeAndPublishFrame(rgbaFrame);
    });
  }

  @override
  void dispose() {
    _frameSubscription?.cancel();
    _latestFrame?.dispose();
    super.dispose();
  }

  Uint8List? getCurrentFrameJpeg() {
    final rgbaFrame = _latestFrameBytes;
    if (rgbaFrame == null) {
      return null;
    }

    final image = img.Image.fromBytes(
      width: ref.read(liveStreamServiceProvider).width,
      height: ref.read(liveStreamServiceProvider).height,
      bytes: rgbaFrame.buffer,
      numChannels: 4,
    );

    return Uint8List.fromList(img.encodeJpg(image));
  }

  void _decodeAndPublishFrame(Uint8List rgbaFrame) {
    _latestFrameBytes = rgbaFrame;

    ui.decodeImageFromPixels(
      rgbaFrame,
      ref.read(liveStreamServiceProvider).width,
      ref.read(liveStreamServiceProvider).height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) {
        if (!mounted) {
          image.dispose();
          return;
        }

        setState(() {
          _latestFrame?.dispose();
          _latestFrame = image;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveStreamService = ref.watch(liveStreamServiceProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: liveStreamService.width / liveStreamService.height,
          child: CustomPaint(
            painter: _LiveImagePainter(image: _latestFrame),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _LiveImagePainter extends CustomPainter {
  const _LiveImagePainter({required this.image});

  final ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    if (image != null) {
      final sourceRect = Rect.fromLTWH(
        0,
        0,
        image!.width.toDouble(),
        image!.height.toDouble(),
      );

      final destinationRect = Offset.zero & size;
      canvas.drawImageRect(image!, sourceRect, destinationRect, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant _LiveImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
