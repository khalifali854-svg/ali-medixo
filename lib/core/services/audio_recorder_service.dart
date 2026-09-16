import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AudioRecorderService {
  static final AudioRecorder _audioRecorder = AudioRecorder();
  static String? _currentRecordingPath;
  static bool _isRecording = false;

  static bool get isRecording => _isRecording;

  /// Start recording (supports Mobile and Web)
  static Future<bool> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          _currentRecordingPath = null;
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.opus),
            path: '',
          );
        } else {
          final dir = await getTemporaryDirectory();
          final filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
          _currentRecordingPath = filePath;

          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: filePath,
          );
        }

        _isRecording = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording and return recorded audio bytes
  static Future<Uint8List?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;

      final targetPath = path ?? _currentRecordingPath;
      if (targetPath != null) {
        if (kIsWeb) {
          if (targetPath.startsWith('blob:') || targetPath.startsWith('http')) {
            for (int retry = 0; retry < 6; retry++) {
              try {
                final res = await http.get(Uri.parse(targetPath));
                if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
                  debugPrint('Web audio recording captured: ${res.bodyBytes.lengthInBytes} bytes');
                  return res.bodyBytes;
                }
              } catch (e) {
                debugPrint('Web audio fetch attempt note: $e');
              }
              await Future.delayed(const Duration(milliseconds: 80));
            }
          }
          return null;
        } else {
          String cleanPath = targetPath;
          if (cleanPath.startsWith('file://')) {
            try {
              cleanPath = Uri.parse(cleanPath).toFilePath();
            } catch (_) {
              cleanPath = cleanPath.replaceFirst('file://', '');
            }
          }

          final file = File(cleanPath);
          for (int retry = 0; retry < 8; retry++) {
            if (await file.exists() && await file.length() > 0) {
              final bytes = await file.readAsBytes();
              debugPrint('Audio recording captured successfully: ${bytes.lengthInBytes} bytes from $cleanPath');
              return bytes;
            }
            await Future.delayed(const Duration(milliseconds: 70));
          }
          debugPrint('Audio file missing or empty after stop at $cleanPath');
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      _isRecording = false;
      return null;
    }
  }
}
