import 'package:flutter/foundation.dart';
import 'package:guardian_project/intl.dart';
import 'package:guardian_project/main.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:workmanager/workmanager.dart';

/// service wrapping the [Workmanager] to launch a background activity
///
/// The main objective of this service, is to build a single background task and handle it
class BackgroundTaskService {
  // background task tags
  static const String backgroundTaskName = "on_listening_background_task";
  static const String backgroundTaskTag = "on_listening_background_task_tag";

  static const String listeningConditionTag = "listeningCondition";
  static const String actionTag = "action";

  /// the background service unique task is alive
  bool get taskIsAlive => _taskIsAlive;
  bool _taskIsAlive = false;

  final ToastService _toastService;

  final Workmanager _workmanager;
  BackgroundTask _backgroundTask;

  BackgroundTaskService.init(this._toastService)
      : _backgroundTask = BackgroundTask(),
        _workmanager = Workmanager();

  /// set the background task action
  void setBackgroundTaskAction(String action) => _backgroundTask = _backgroundTask.copyWith(action: action);

  /// set the background task listening condition
  void setBackgroundTaskListeningCondition(String listeningCondition) =>
      _backgroundTask = _backgroundTask.copyWith(listeningCondition: listeningCondition);

  /// start the [_backgroundTask] task
  Future<void> startTaskAsync() async {
    // builds the background task
    await _buildBackgroundTaskAsync();

    if (callbackDispatcher == null) {
      _toastService.showToast(
          "build dispatcher before atempting to launch a background task. Use ${_buildBackgroundTaskAsync.toString()} to do so",
          criticity: ToastCriticity.error);
      return;
    }

    _workmanager.registerOneOffTask(backgroundTaskName, backgroundTaskName,
        tag: backgroundTaskTag,
        existingWorkPolicy: ExistingWorkPolicy.keep,
        inputData: {actionTag: _backgroundTask.action, listeningConditionTag: _backgroundTask.listeningCondition});
  }

  /// cancel the [_backgroundTask] task
  Future<void> cancelTaskAsync() async {
    await _workmanager.cancelByTag(backgroundTaskTag);
    _taskIsAlive = false;
  }

  /// build the background task dispatcher and initialize the [Workmanager] with it
  Future<void> _buildBackgroundTaskAsync() async {
    if (_backgroundTask.action == null || _backgroundTask.listeningCondition == null) {
      _toastService.showToast(
          "Can't build the dispatcher function because either the ${_backgroundTask.action.toString()} or the ${_backgroundTask.listeningCondition.toString()} are not specified",
          criticity: ToastCriticity.error);
      return;
    }

    // actually build the dispatcher function
    callbackDispatcher = () => _workmanager.executeTask((taskName, inputData) async {
          // infinite loop
          // ### TODO : create noise alert detection service
          // ### TODO : create voice recognition service
          try {
            if (_taskIsAlive) throw Exception(tr.background_task_service_already_alive_task_error_label);

            _taskIsAlive = true;
            while (_taskIsAlive) {
              if (inputData?[listeningConditionTag] == "true") {
                _taskIsAlive = false;
                return Future.value(true);
              }
            }
          } catch (ex) {
            _taskIsAlive = false;
            return Future.value(false);
          }

          // if it goes here, means the task has gone wrong
          return Future.value(false);
        });

    // initialize the [Workmanager]
    await _workmanager.initialize(callbackDispatcher!, isInDebugMode: kDebugMode);
  }
}

/// Holds information on the background task triggered by the [Workmanager]
class BackgroundTask {
  final String? action;
  final String? listeningCondition;

  BackgroundTask({this.action, this.listeningCondition});

  BackgroundTask copyWith({String? action, String? listeningCondition}) =>
      BackgroundTask(action: action ?? this.action, listeningCondition: listeningCondition ?? this.listeningCondition);
}
