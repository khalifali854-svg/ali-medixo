import 'package:flutter/widgets.dart';

Widget createWebImage(String url, {BoxFit fit = BoxFit.cover}) {
  return Image.network(
    url,
    fit: fit,
  );
}
