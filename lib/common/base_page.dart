import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// -------------------------------------------------------------
// Method described here : Build a page
// - Use a [BasePage] to design UI
// - Use a [BasePageController] with a [BasePageControllerState] to design any computation logic
//
// This allow to separate the logic from the view. The controller will notify the Page
// -------------------------------------------------------------

/// Base class to create a page
abstract class BasePage<T extends BasePageController> extends StatelessWidget {
  const BasePage(this.pageController, {super.key});

  /// As page always use [WillPopScope], the onWillPop callback is required to build a page
  ///
  /// It's a callback that will be called whenever the back process is called
  Future<bool> onWillPop();

  /// Build the inner content of the page
  Widget getContent(BuildContext context);

  /// page controller as [BasePageController]
  final T pageController;

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: onWillPop,
      child: ChangeNotifierProvider<T>.value(
          value: pageController, child: Consumer<T>(builder: (context, controller, _) => getContent(context))));
}

/// Controller to hold [BasePage] logic
abstract class BasePageController<T extends BasePageControllerState> extends ChangeNotifier {
  /// the controller's state
  T get stateData => _stateData;
  late final T _stateData;

  /// base ctor
  ///
  /// Only calls [initAsync]
  BasePageController(T stateData) {
    _stateData = stateData;
    initAsync();
  }

  /// init the controller
  void initAsync();

  /// use to handle async codes without waiting for it
  ///
  /// Add some error management
  void fireAndForget(Future<void> future, [bool withControllerHandling = false]) async {
    try {
      if (withControllerHandling) _stateData.addRunningProcess(future);
      await future;
    } catch (ex) {
      _setError(ex);
    }
    notifyListeners();
  }

  /// set an error on the state
  void _setError(Object error) {
    _stateData.setError(error);
    notifyListeners();
  }

  void resetError() {
    stateData.resetError();
    notifyListeners();
  }
}

/// Base state to use with [BasePage]
abstract class BasePageControllerState extends BaseAsyncState {}

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
