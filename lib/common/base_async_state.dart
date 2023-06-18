/// Base class to create an asynchronous state
abstract class BaseAsyncState {
  /// this controller has error
  bool get hasError => _error != null;
  Object? _error;

  /// this controller is busy
  bool get isBusy => _runningProcesses.isNotEmpty;
  final Map<int, Future> _runningProcesses = {};

  /// set an error
  void setError(Object error) => _error = error;

  /// reset an error
  void resetError() => _error = null;

  /// add a process to the associated controller handling processes
  void addRunningProcess(Future future) => _runningProcesses[future.hashCode] =
      future.whenComplete(() => _runningProcesses.removeWhere((key, value) => key == future.hashCode));

  /// get the error formatted as string
  String getFormattedError() => _error.toString();
}

/// Base state to use with [BaseViewPage]
abstract class BasePageControllerState extends BaseAsyncState {}
