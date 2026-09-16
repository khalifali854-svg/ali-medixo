// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

final Set<String> _registeredViews = {};

Widget buildPlatformNetworkImage({
  required String imageUrl,
  required BoxFit fit,
  double? width,
  double? height,
  required Widget placeholder,
  required Widget errorWidget,
}) {
  final viewType = 'ali-img-${imageUrl.hashCode}';

  if (!_registeredViews.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final img = html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..style.outline = 'none'
        ..style.userSelect = 'none'
        ..style.pointerEvents = 'none'
        ..draggable = false;

      switch (fit) {
        case BoxFit.cover:
          img.style.objectFit = 'cover';
          break;
        case BoxFit.contain:
          img.style.objectFit = 'contain';
          break;
        case BoxFit.fill:
          img.style.objectFit = 'fill';
          break;
        case BoxFit.fitWidth:
          img.style.objectFit = 'contain';
          break;
        case BoxFit.fitHeight:
          img.style.objectFit = 'contain';
          break;
        default:
          img.style.objectFit = 'cover';
      }

      return img;
    });
    _registeredViews.add(viewType);
  }

  return IgnorePointer(
    child: SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(viewType: viewType),
    ),
  );
}
