import 'dart:async';
import 'package:guardian_project/service/sound_meter_service.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

/// ## Noise level detector service
///
/// **Purpose : detect when the average surrounding noise level has significantly changed**
///
/// It uses a gliding window of values, and each new sound record is buffed before being process
///
/// To use it, call
/// ```serviceLocator<NoiseLevelDetector>().watcher```, witch returns a stream of boolean
class NoiseLevelDetectorService {
  // constants for gliding windows
  static const _glidingWindowSize = 70;
  static const _glidingPeakEventSize = 4;

  /// dB treshold
  static const _treshold = 10;
  bool _tresholdReached = false;
  int _countReachedTreshold = 0;

  late final Stream<bool> watcher;
  final GlidingList<double> glidingRecordWindow = GlidingList(_glidingWindowSize);

  final SoundMeterService _soundMeterService;
  StreamSubscription<NoiseReading>? _soundMeterServiceSubscription;

  NoiseLevelDetectorService.init(this._soundMeterService) {
    _soundMeterServiceSubscription ??= _soundMeterService.subscribeTo(StreamController()
      ..stream.listen((event) {
        glidingRecordWindow.append(event.maxDecibel);
      }));

    _watch();
  }

  /// pause the sound level detector
  ///
  /// It actually stops feeding the detector with new sound records
  void pause() => _soundMeterService.pauseSubscription(_soundMeterServiceSubscription.hashCode);

  /// resume the sound level detector by resuming it's internal sound record feed
  void resume() => _soundMeterService.resumeSubscription(_soundMeterServiceSubscription.hashCode);

  /// process when a new record is added to the window (when window is full)
  bool _newRecordInWindow(double record) {
    // increment/decrement peak event buffer
    if ((record - glidingRecordWindow.getMean()) >= _treshold && _countReachedTreshold < _glidingPeakEventSize) {
      _countReachedTreshold++;
    } else if ((record - glidingRecordWindow.getMean()) < _treshold && _countReachedTreshold > 0) {
      _countReachedTreshold--;
    }

    // if maximum/minimum amount of peak values is reached -> changed the _tresholdReached value
    if (_countReachedTreshold == _glidingPeakEventSize) {
      _tresholdReached = true;
    } else if (_countReachedTreshold == 0) {
      _tresholdReached = false;
    }

    return _tresholdReached;
  }

  /// create a stream that returs [_tresholdReached] for each new value added in the gliding window
  void _watch() {
    final watcherController = StreamController<bool>.broadcast();
    final sub = StreamController<double>();
    glidingRecordWindow.addSubscriber(sub);
    sub.stream.listen((event) => watcherController.sink.add(_newRecordInWindow(event)));
    watcher = watcherController.stream;
  }
}

/// Sized list where adding values removes the olest ones
class GlidingList<T extends num> {
  final List<T> _innerList = [];
  final List<StreamController<T>> _subscribers = [];

  final int size;
  final int meanBufferSize;

  GlidingList(this.size) : meanBufferSize = size ~/ 4;

  /// append an element at the end of the list, removing the first one if [size] is exceeded
  void append(T newValue) {
    if (_innerList.length == size) {
      _innerList.removeAt(0);
    }

    _innerList.add(newValue);

    if (_isFullLength()) {
      // send data to subscribers
      for (var sub in _subscribers) {
        sub.sink.add(newValue);
      }
    }
  }

  /// get the mean value of the [GlidingList]
  double getMean() => _innerList.average;

  /// register a new subscriber to this list
  void addSubscriber(StreamController<T> streamController) => _subscribers.add(streamController);

  /// tells if the list is full
  bool _isFullLength() => _innerList.length == size;
}
