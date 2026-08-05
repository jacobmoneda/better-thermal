import 'dart:typed_data';

import 'package:better_thermal/services/ftp_service/directory_entry_file.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'ftp_image_renderer.dart';

class FtpThermalImage extends FtpImageRenderer {
  const FtpThermalImage({super.key, required this.image});

  final DirectoryEntryFile image;

  @override
  Uint8List getImageJpeg() {
    final decoded = img.decodeImage(image.thermalImage);
    if (decoded == null) {
      throw const FormatException('Unable to decode thermal image');
    }

    return Uint8List.fromList(img.encodeJpg(decoded));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: image.width / image.height,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(4),
        child: Image.memory(
          image.thermalImage,
          fit: BoxFit.contain,
          errorBuilder: (_, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      ),
    );
  }
}
