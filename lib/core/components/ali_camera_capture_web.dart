// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_button.dart';
import 'ali_icon.dart';

Future<Uint8List?> showWebCameraModal(BuildContext context) async {
  return await showDialog<Uint8List?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _WebCameraDialog(),
  );
}

class _WebCameraDialog extends StatefulWidget {
  const _WebCameraDialog();

  @override
  State<_WebCameraDialog> createState() => _WebCameraDialogState();
}

class _WebCameraDialogState extends State<_WebCameraDialog> {
  html.VideoElement? _videoElement;
  html.MediaStream? _mediaStream;
  String? _viewType;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final uniqueId = 'webcam-view-${DateTime.now().millisecondsSinceEpoch}';
    _viewType = uniqueId;

    try {
      final video = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.borderRadius = '16px'
        ..setAttribute('playsinline', 'true');

      final mediaDevices = html.window.navigator.mediaDevices;
      if (mediaDevices == null) {
        throw Exception('MediaDevices API tidak didukung di browser ini.');
      }

      final stream = await mediaDevices.getUserMedia({
        'video': {
          'facingMode': 'environment',
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        },
        'audio': false,
      });

      _mediaStream = stream;
      video.srcObject = stream;
      _videoElement = video;

      ui_web.platformViewRegistry.registerViewFactory(uniqueId, (int viewId) => video);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal mengakses kamera: $e\nPastikan Anda memberikan izin akses kamera pada browser.';
        });
      }
    }
  }

  Uint8List? _captureFrame() {
    if (_videoElement == null) return null;

    final video = _videoElement!;
    final width = video.videoWidth > 0 ? video.videoWidth : 640;
    final height = video.videoHeight > 0 ? video.videoHeight : 480;

    final canvas = html.CanvasElement(width: width, height: height);
    final ctx = canvas.context2D;
    ctx.drawImage(video, 0, 0);

    final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);
    final base64String = dataUrl.split(',').last;
    return base64Decode(base64String);
  }

  void _closeCamera() {
    try {
      _mediaStream?.getTracks().forEach((track) => track.stop());
    } catch (_) {}
  }

  @override
  void dispose() {
    _closeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Container(
          width: 540,
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 680),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(color: AppColors.borderCard, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentLemon.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: AliIcon(Iconsax.camera, color: AppColors.accentLemon, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kamera Langsung Ali',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Arahkan kamera ke benda atau kartu, lalu ambil foto',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () {
                        _closeCamera();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderCard),

              // Viewport Kamera
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isLoading)
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.accentLemon),
                              SizedBox(height: AppSpacing.s12),
                              Text(
                                'Menyiapkan kamera...',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          )
                        else if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.camera_slash, color: Colors.redAccent, size: 36),
                                const SizedBox(height: AppSpacing.s8),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        else if (_viewType != null)
                          HtmlElementView(viewType: _viewType!),

                        // Camera Guide Target Overlay
                        if (!_isLoading && _errorMessage == null)
                          IgnorePointer(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.35),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: AliButton(
                        label: 'Batal',
                        variant: AliButtonVariant.outline,
                        onPressed: () {
                          _closeCamera();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      flex: 2,
                      child: AliButton(
                        label: 'Ambil Foto Sekarang',
                        variant: AliButtonVariant.primaryHighContrast,
                        prefixIcon: AliIcon(Iconsax.camera, color: Colors.white, size: 18),
                        onPressed: (_isLoading || _errorMessage != null)
                            ? null
                            : () {
                                final bytes = _captureFrame();
                                _closeCamera();
                                Navigator.pop(context, bytes);
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
