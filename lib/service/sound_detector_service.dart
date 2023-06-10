import 'dart:async';
import 'package:guardian_project/service/sound_meter_service.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

/// ## Sound level detector service
///
/// **Purpose : detect when the average surrounding noise level has significantly changed**
///
/// It uses a gliding window of values, and each new sound record is buffed before being process
///
/// To use it, call
/// ```serviceLocator<NoiseLevelDetector>().watcher```, witch returns a stream of boolean
class SoundLevelDetectorService {
  // constants for gliding windows
  static const _glidingWindowSize = 100;
  static const _glidingPeakEventSize = 6;

  /// dB treshold
  static const _treshold = 9;

  bool _tresholdReached = false;
  int _countReachedTreshold = 0;

  /// [Stream] that returns a boolean whether or not the level has significantly changed
  late final Stream<bool> watcher;

  /// The mean value of this [SoundLevelDetectorService]
  double get meanValue => _glidingRecordWindow.getMean();

  late final _GlidingList<double, bool> _glidingRecordWindow;

  final SoundMeterService _soundMeterService;
  StreamSubscription<NoiseReading>? _soundMeterServiceSubscription;

  SoundLevelDetectorService.init(this._soundMeterService) {
    // subscribe to sound meter service
    _soundMeterServiceSubscription ??= _soundMeterService.subscribeTo(StreamController()
      ..stream.listen((event) {
        _glidingRecordWindow.append(event.maxDecibel);
      }));

    // build the watch stream
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
    var treshold = _computeTreshold();
    // increment/decrement peak event buffer
    if ((record - _glidingRecordWindow.getMean()) >= treshold && _countReachedTreshold < _glidingPeakEventSize) {
      _countReachedTreshold++;
    } else if ((record - _glidingRecordWindow.getMean()) < treshold && _countReachedTreshold > 0) {
      _countReachedTreshold--;
    }

    // if maximum/minimum amount of peak values is reached -> changed the _tresholdReached value
    if (_countReachedTreshold == _glidingPeakEventSize) {
      _tresholdReached = true;
    } else {
      _tresholdReached = false;
    }

    return _tresholdReached;
  }

  /// create a stream [watcher] that returns [_tresholdReached] for each new value added in the gliding window
  void _watch() {
    final watcherController = StreamController<bool>.broadcast();
    _glidingRecordWindow = _GlidingList<double, bool>(
        size: _glidingWindowSize,
        subscriber: _GlidingListSubscriber<double, bool>(subscriber: watcherController, onAdd: _newRecordInWindow));
    watcher = watcherController.stream;
  }

  /// compute the treshold value based on the average noise value
  double _computeTreshold() => _treshold - _glidingRecordWindow.getMean() / 10;
}

/// Sized list where adding values removes the oldest ones
///
/// Holds a subscriber [_GlidingListSubscriber] that reacts whenever a value is added once the list is full
class _GlidingList<TList extends num, TSub> {
  final List<TList> _innerList = [];
  final _GlidingListSubscriber<TList, TSub> subscriber;

  final int size;
  final int meanBufferSize;

  _GlidingList({required this.size, required this.subscriber}) : meanBufferSize = size ~/ 4;

  /// append an element at the end of the list, removing the first one if [size] is exceeded
  /// also add
  void append(TList newValue) {
    if (_innerList.length == size) {
      _innerList.removeAt(0);
    }

    _innerList.add(newValue);

    // send data to the subscriber
    if (_isMeaningful()) {
      subscriber.add(newValue);
    }
  }

  /// get the mean value of the [_GlidingList]
  double getMean() => _innerList.average;

  /// tells if the list is full
  bool _isMeaningful() => _innerList.length >= size / 2;
}

/// This discribes a [_GlidingList] subscriber
class _GlidingListSubscriber<Tin, Tout> {
  StreamController<Tout> subscriber;
  Tout Function(Tin value) onAdd;

  _GlidingListSubscriber({required this.subscriber, required this.onAdd});

  /// Add a new value to the subscriber
  void add(Tin event) => subscriber.sink.add(onAdd(event));
}
