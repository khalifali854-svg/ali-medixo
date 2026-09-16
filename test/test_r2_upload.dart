import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:khalif_ali/core/constants/app_config.dart';

List<int> _sign(List<int> key, String msg) {
  return Hmac(sha256, key).convert(utf8.encode(msg)).bytes;
}

List<int> _getSignatureKey(String key, String dateStamp, String regionName, String serviceName) {
  final kDate = _sign(utf8.encode('AWS4$key'), dateStamp);
  final kRegion = _sign(kDate, regionName);
  final kService = _sign(kRegion, serviceName);
  return _sign(kService, 'aws4_request');
}

Future<int> tryUpload({required String region, required String path, required String contentType, required Uint8List bytes, bool virtualHosted = false}) async {
  final now = DateTime.now().toUtc();
  final dateStamp = '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final amzDate = '${dateStamp}T${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}Z';

  final host = virtualHosted
      ? '${AppConfig.r2BucketName}.${AppConfig.r2AccountId}.r2.cloudflarestorage.com'
      : '${AppConfig.r2AccountId}.r2.cloudflarestorage.com';
  final canonicalUri = virtualHosted ? '/$path' : '/${AppConfig.r2BucketName}/$path';
  final payloadHash = sha256.convert(bytes).toString();

  final canonicalHeaders = 'content-type:$contentType\nhost:$host\nx-amz-content-sha256:$payloadHash\nx-amz-date:$amzDate\n';
  const signedHeaders = 'content-type;host;x-amz-content-sha256;x-amz-date';

  final canonicalRequest = [
    'PUT',
    canonicalUri,
    '',
    canonicalHeaders,
    signedHeaders,
    payloadHash,
  ].join('\n');

  const algorithm = 'AWS4-HMAC-SHA256';
  final credentialScope = '$dateStamp/$region/s3/aws4_request';
  final stringToSign = [
    algorithm,
    amzDate,
    credentialScope,
    sha256.convert(utf8.encode(canonicalRequest)).toString(),
  ].join('\n');

  final signingKey = _getSignatureKey(AppConfig.r2SecretKey, dateStamp, region, 's3');
  final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

  final authorization = '$algorithm Credential=${AppConfig.r2AccessKey}/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';
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

  print('VH: $virtualHosted, Region: $region, Status: ${response.statusCode}, Body: ${response.body}');
  return response.statusCode;
}

void main() {
  test('R2 upload diagnostic', () async {
    final testBytes = Uint8List.fromList(utf8.encode('Hello R2 Test'));
    final res = await tryUpload(region: 'auto', path: 'catalog/flutter_test.txt', contentType: 'text/plain', bytes: testBytes, virtualHosted: false);
    expect(res, 200);
  });
}
