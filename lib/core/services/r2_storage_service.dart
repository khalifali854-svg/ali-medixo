import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../constants/app_config.dart';

/// Cloudflare R2 Upload Service with AWS Signature Version 4
class R2StorageService {
  static Future<String?> uploadFile({
    required Uint8List bytes,
    required String path, // e.g. "photos/mobil.jpg" or "audio/makan.mp3"
    required String contentType,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final amzDate = _formatAmzDate(now);
      final dateStamp = _formatDateStamp(now);

      final host = '${AppConfig.r2AccountId}.r2.cloudflarestorage.com';
      final canonicalUri = '/${AppConfig.r2BucketName}/$path';
      final payloadHash = sha256.convert(bytes).toString();

      // 1. Canonical Headers & Signed Headers
      final canonicalHeaders =
          'content-type:$contentType\nhost:$host\nx-amz-content-sha256:$payloadHash\nx-amz-date:$amzDate\n';
      const signedHeaders = 'content-type;host;x-amz-content-sha256;x-amz-date';

      // 2. Canonical Request
      final canonicalRequest = [
        'PUT',
        canonicalUri,
        '', // Query string
        canonicalHeaders,
        signedHeaders,
        payloadHash,
      ].join('\n');

      // 3. String to Sign
      const algorithm = 'AWS4-HMAC-SHA256';
      final credentialScope = '$dateStamp/auto/s3/aws4_request';
      final stringToSign = [
        algorithm,
        amzDate,
        credentialScope,
        sha256.convert(utf8.encode(canonicalRequest)).toString(),
      ].join('\n');

      // 4. Signing Key
      final signingKey = _getSignatureKey(
        AppConfig.r2SecretKey,
        dateStamp,
        'auto',
        's3',
      );
      final signature = Hmac(sha256, signingKey)
          .convert(utf8.encode(stringToSign))
          .toString();

      // 5. Authorization Header
      final authorization =
          '$algorithm Credential=${AppConfig.r2AccessKey}/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';

      final uri = Uri.parse('https://$host$canonicalUri');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': contentType,
          'x-amz-date': amzDate,
          'x-amz-content-sha256': payloadHash,
          'Authorization': authorization,
        },
        body: bytes,
      );

      debugPrint('R2 Upload result: status ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final publicUrl = '${AppConfig.r2PublicBaseUrl}/$path';
        debugPrint('R2 Upload successful -> $publicUrl');
        return publicUrl;
      } else {
        debugPrint('R2 Upload error: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('R2 Upload exception: $e');
      return null;
    }
  }

  /// Download remote image (e.g. Unsplash, Google Search image, etc) and re-upload directly to R2 bucket
  static Future<String?> uploadFileFromRemoteUrl({
    required String remoteUrl,
    required String path,
  }) async {
    try {
      final res = await http.get(Uri.parse(remoteUrl));
      if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
        String contentType = 'image/jpeg';
        final headerType = res.headers['content-type'];
        if (headerType != null && headerType.isNotEmpty) {
          contentType = headerType.split(';').first.trim();
        }
        return await uploadFile(
          bytes: res.bodyBytes,
          path: path,
          contentType: contentType,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading remote URL to R2: $e');
      return null;
    }
  }

  static List<int> _sign(List<int> key, String msg) {
    return Hmac(sha256, key).convert(utf8.encode(msg)).bytes;
  }

  static List<int> _getSignatureKey(
      String key, String dateStamp, String regionName, String serviceName) {
    final kDate = _sign(utf8.encode('AWS4$key'), dateStamp);
    final kRegion = _sign(kDate, regionName);
    final kService = _sign(kRegion, serviceName);
    final kSigning = _sign(kService, 'aws4_request');
    return kSigning;
  }

  static String _formatAmzDate(DateTime dt) {
    return '${_formatDateStamp(dt)}T'
        '${dt.hour.toString().padLeft(2, '0')}'
        '${dt.minute.toString().padLeft(2, '0')}'
        '${dt.second.toString().padLeft(2, '0')}Z';
  }

  static String _formatDateStamp(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}'
        '${dt.month.toString().padLeft(2, '0')}'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}
