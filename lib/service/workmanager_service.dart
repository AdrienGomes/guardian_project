import 'package:flutter/foundation.dart';
import 'package:guardian_project/main.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:workmanager/workmanager.dart';

/// service wrapping the [Workmanager] to launch a background activity
///
/// The main objective of this service, is to build a background task and handle it
class BackgroundTaskService {
  static const String backgroundTaskName = "on_listening_background_task";
  static const String backgroundTaskTag = "on_listening_background_task_tag";

  static const String listeningConditionTag = "listeningCondition";
  static const String actionTag = "action";

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

  /// build the background task dispatcher and initialize the [Workmanager] with it
  void buildBackgroundTask() {
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
          while (true) {
            if (inputData?[listeningConditionTag] == "true") {
              print(inputData?[actionTag]);
            }
          }
        });

    // initialize the [Workmanager]
    _workmanager.initialize(callbackDispatcher!, isInDebugMode: kDebugMode);
  }

  /// start the [_backgroundTask] task
  void startTask() {
    if (callbackDispatcher == null) {
      _toastService.showToast(
          "build dispatcher before atempting to launch a background task. Use ${buildBackgroundTask.toString()} to do so",
          criticity: ToastCriticity.error);
    }

    _workmanager.registerOneOffTask(backgroundTaskName, backgroundTaskName,
        tag: backgroundTaskTag,
        inputData: {actionTag: _backgroundTask.action, listeningConditionTag: _backgroundTask.listeningCondition});
  }

  /// cancel the [_backgroundTask] task
  void cancelTask() => _workmanager.cancelByTag(backgroundTaskTag);
}

/// Holds information on the background task triggered by the [Workmanager]
class BackgroundTask {
  final String? action;
  final String? listeningCondition;

  BackgroundTask({this.action, this.listeningCondition});

  BackgroundTask copyWith({String? action, String? listeningCondition}) =>
      BackgroundTask(action: action ?? this.action, listeningCondition: listeningCondition ?? this.listeningCondition);
}
