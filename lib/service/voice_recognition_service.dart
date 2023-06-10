import 'dart:async';

import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

/// ## Voice recognition service
///
/// **Purpose : start a listening session for a specific sentence**
///
/// To use it, add a listening session with the [addListeningSession] method. It requires to define a [ListeningSession] object before,
/// with a hotSentence to be searched into recognized words
///
class VoiceRecognitionService {
  /// listening session's timeout
  static const Duration _listeningSessionTimeOut = Duration(seconds: 5);

  /// minimum confidence trust
  static const double _confidenceMinimumTrust = 0.7;

  /// if true, means the microphones needs to be freed
  bool needMicOff = false;

  final ToastService _toastService;
  final SoundMeterService _soundMeterService;

  VoiceRecognitionService.init(this._toastService, this._soundMeterService) {
    _listeningSessionQueue = StreamController<ListeningSession>()
      ..stream.listen((event) async {
        if (_speech.isListening) return;
        await _listen(event);
      });
  }

  /// [SpeechToText] instance
  final stt.SpeechToText _speech = stt.SpeechToText();

  /// [StreamController] to control listening session
  late final StreamController _listeningSessionQueue;

  /// true if [_speech] is listening
  bool get isListening => _speech.isListening;

  /// start a listening session
  Future<void> _listen(ListeningSession listeningSession) async {
    // initialize speech recognition
    final available = await _speech.initialize(
      debugLogging: true,
      finalTimeout: _listeningSessionTimeOut,
      onStatus: _handleStatus,
      onError: (val) => _handleStatus(val.errorMsg),
    );
    if (available) {
      _speech.listen(
        listenFor: _listeningSessionTimeOut,
        listenMode: stt.ListenMode.dictation,
        sampleRate: 44100, // android value, might need to change when attempting using it with IOS
        onResult: (result) {
          final recognizedWords = result.recognizedWords;
          if (result.isConfident(threshold: _confidenceMinimumTrust)) {
            if (recognizedWords.toLowerCase().contains(listeningSession.hotSentence.toLowerCase())) {
              listeningSession.onRecognizedSentence();

              _speech.cancel();
              // empty the queue
              _listeningSessionQueue.stream.drain();
            }
          }
        },
      );
    }
  }

  /// get the [ListeningStatus] matching the textStatus comming from the SpeechToText onStatus handler
  ListeningStatus _getStatusFromString(String textStatus) => ListeningStatus.values
      .firstWhere((status) => status.name == textStatus, orElse: () => ListeningStatus.notListening);

  /// handle status changes
  void _handleStatus(String textStatus) {
    final status = _getStatusFromString(textStatus);
    switch (status) {
      case ListeningStatus.done:
      case ListeningStatus.notListening:
        {
          needMicOff = false;
          break;
        }
      case ListeningStatus.listening:
        {
          needMicOff = true;
          _soundMeterService.askForPause(_listeningSessionTimeOut, interruptionCallabck: () => !needMicOff);
          break;
        }
      default:
        {
          _toastService.showToast(textStatus, criticity: ToastCriticity.error);
          _speech.cancel();
          needMicOff = false;
        }
    }
  }

  /// add a listening session into the queue
  void addListeningSession(ListeningSession session) => _listeningSessionQueue.sink.add(session);
}

/// voice recognition statuses
enum ListeningStatus { listening, notListening, done }

/// holds information about a listening session
class ListeningSession {
  final String hotSentence;

  final void Function() onRecognizedSentence;

  ListeningSession({required this.hotSentence, required this.onRecognizedSentence});
}
