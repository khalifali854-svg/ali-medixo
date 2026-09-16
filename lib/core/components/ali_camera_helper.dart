import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ali_camera_capture_stub.dart'
    if (dart.library.html) 'ali_camera_capture_web.dart';

/// Helper cross-platform untuk mengambil foto langsung dari Kamera.
/// Di Web (Chrome Desktop/Mobile), membuka live camera preview modal dengan WebRTC getUserMedia.
/// Di Mobile (Android/iOS), memanggil native ImagePicker(source: ImageSource.camera).
class AliCameraHelper {
  static Future<Uint8List?> capturePhoto(BuildContext context) async {
    if (kIsWeb) {
      return await showWebCameraModal(context);
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        return await picked.readAsBytes();
      }
      return null;
    }
  }
}
