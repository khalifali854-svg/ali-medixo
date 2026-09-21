// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

typedef AudioEndedCallback = void Function();
typedef AudioPositionCallback = void Function(int positionMs);

void webPlayAudioUrl(String url, {AudioEndedCallback? onEnded, AudioPositionCallback? onPosition}) {
  try {
    js.context.callMethod('aliPlayAudioUrl', [
      url,
      if (onEnded != null) js.allowInterop(onEnded) else null,
      if (onPosition != null) js.allowInterop((dynamic pos) {
        if (pos is num) {
          onPosition(pos.toInt());
        }
      }) else null,
    ]);
  } catch (e) {
    // print or ignore
  }
}

void webStopAudio() {
  try {
    js.context.callMethod('aliStopAudio');
  } catch (e) {}
}

void webPauseAudio() {
  try {
    js.context.callMethod('aliPauseAudio');
  } catch (e) {}
}

void webResumeAudio() {
  try {
    js.context.callMethod('aliResumeAudio');
  } catch (e) {}
}
