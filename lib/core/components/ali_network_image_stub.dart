import 'package:flutter/material.dart';

Widget buildPlatformNetworkImage({
  required String imageUrl,
  required BoxFit fit,
  double? width,
  double? height,
  required Widget placeholder,
  required Widget errorWidget,
}) {
  return Image.network(
    imageUrl,
    fit: fit,
    width: width,
    height: height,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return placeholder;
    },
    errorBuilder: (context, error, stackTrace) => errorWidget,
  );
}
