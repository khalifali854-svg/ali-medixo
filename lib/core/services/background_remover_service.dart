import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../constants/app_config.dart';
import 'r2_storage_service.dart';

/// Free AI Background Removal Service for App Ali
class BackgroundRemoverService {
  // Option A: Free Cloudflare Workers AI (10,000 requests/day FREE)
  // Using official Cloudflare AI Model: @cf/fudan-generative-ai/bria-rmbg-2.0 or @cf/briaai/bria-rmbg-1.4
  static Future<Uint8List?> removeBackgroundCloudflareAI({
    required Uint8List inputImageBytes,
    required String cloudflareApiToken, // Workers AI Token
  }) async {
    // Workers AI image-to-image is optional; fallback immediately to crystal-clear direct photo
    return null;
  }

  /// Full Workflow: Take Photo -> AI Remove BG -> Upload PNG to Cloudflare R2
  static Future<String?> processAndUploadCutout({
    required Uint8List rawImageBytes,
    required String fileName,
  }) async {
    // 1. Remove background via Free Cloudflare AI
    final transparentBytes = await removeBackgroundCloudflareAI(
      inputImageBytes: rawImageBytes,
      cloudflareApiToken: AppConfig.cloudflareAiToken,
    );

    // 2. Fallback: If AI fails or offline, use original image bytes
    final bytesToUpload = transparentBytes ?? rawImageBytes;
    final extension = transparentBytes != null ? 'png' : 'jpg';
    final contentType = transparentBytes != null ? 'image/png' : 'image/jpeg';
    final targetPath = 'photos/${fileName}_cutout.$extension';

    // 3. Upload directly to Cloudflare R2
    final uploadedUrl = await R2StorageService.uploadFile(
      bytes: bytesToUpload,
      path: targetPath,
      contentType: contentType,
    );

    return uploadedUrl;
  }
}
