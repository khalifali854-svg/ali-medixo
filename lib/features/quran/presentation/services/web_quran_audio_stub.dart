// Stub untuk platform non-web (Android, iOS, macOS, Windows)
typedef AudioEndedCallback = void Function();
typedef AudioPositionCallback = void Function(int positionMs);

void webPlayAudioUrl(String url, {AudioEndedCallback? onEnded, AudioPositionCallback? onPosition}) {}
void webStopAudio() {}
void webPauseAudio() {}
void webResumeAudio() {}
