import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'date_utils.dart';

class ImageUtils {
  ImageUtils._();

  static const _uuid = Uuid();

  /// Decode → fix EXIF orientation → resize to max [maxDimension] →
  /// burn timestamp overlay → save as JPEG at [quality].
  static Future<File> processPhoto(
      File sourceFile, {
        int maxDimension = 1200,
        int quality = 80,
        double? latitude,
        double? longitude,
      }) async {
    final bytes = await sourceFile.readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) throw Exception('Could not decode image');

    // Fix EXIF orientation
    image = img.bakeOrientation(image);

    // Resize if necessary
    if (image.width > maxDimension || image.height > maxDimension) {
      if (image.width >= image.height) {
        image = img.copyResize(image, width: maxDimension);
      } else {
        image = img.copyResize(image, height: maxDimension);
      }
    }

    // Burn timestamp + coordinates overlay
    final now = DateTime.now();
    final overlay = _buildOverlayText(now, latitude, longitude);
    image = img.drawString(
      image,
      overlay,
      font: img.arial14,
      x: 10,
      y: image.height - 30,
      color: img.ColorRgb8(255, 255, 255),
    );

    final dir = await getApplicationDocumentsDirectory();
    final outPath = p.join(dir.path, 'photos', '${_uuid.v4()}.jpg');
    await Directory(p.dirname(outPath)).create(recursive: true);

    final outFile = File(outPath);
    await outFile.writeAsBytes(img.encodeJpg(image, quality: quality));
    return outFile;
  }

  static String _buildOverlayText(
      DateTime dt,
      double? lat,
      double? lon,
      ) {
    final ts = AppDateUtils.formatOverlay(dt);
    if (lat != null && lon != null) {
      return '$ts  ${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';
    }
    return ts;
  }

  /// Compress raw bytes (e.g., signature PNG) to JPEG.
  static Future<Uint8List> compressBytes(
      Uint8List bytes, {
        int quality = 90,
      }) async {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }
}