// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void callAliSpeakText(String text, String lang, bool isUmma) {
  try {
    js.context.callMethod('aliSpeakText', [text, lang, isUmma, null]);
  } catch (e) {}
}
