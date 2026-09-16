import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ali_icon.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';

import 'ali_network_image_stub.dart'
    if (dart.library.html) 'ali_network_image_web.dart' as platform_impl;

class AliNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AliNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _defaultErrorWidget();
    }

    // 1. Base64 data URI
    if (imageUrl.startsWith('data:image')) {
      try {
        final commaIndex = imageUrl.indexOf(',');
        final base64Str = commaIndex != -1 ? imageUrl.substring(commaIndex + 1) : imageUrl;
        return Image.memory(
          base64Decode(base64Str),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => errorWidget ?? _defaultErrorWidget(),
        );
      } catch (_) {
        return errorWidget ?? _defaultErrorWidget();
      }
    }

    // 2. Web with HTML <img> tag (bypasses CORS restrictions)
    if (kIsWeb) {
      return platform_impl.buildPlatformNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: placeholder ?? _defaultPlaceholder(),
        errorWidget: errorWidget ?? _defaultErrorWidget(),
      );
    }

    // 3. Mobile / Desktop — use CachedNetworkImage for reliability
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      httpHeaders: const {
        'User-Agent': 'AliAAC/1.0 Flutter',
      },
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) {
        debugPrint('AliNetworkImage error: $url | $error');
        return errorWidget ?? _defaultErrorWidget();
      },
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: AppColors.surfaceMuted,
      width: width,
      height: height,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      color: AppColors.surfaceCardSubtle,
      width: width,
      height: height,
      child: const Center(
        child: AliIcon(Iconsax.image, size: 24, color: AppColors.textMuted),
      ),
    );
  }
}
