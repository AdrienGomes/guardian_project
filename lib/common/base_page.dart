import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:guardian_project/common/base_async_state.dart';
import 'package:provider/provider.dart';

// -------------------------------------------------------------
// Method described here : Build a page to be used with [Navigator.push] method
// - Use a [BasePage] to design UI
// - Use a [BasePageController] with a [BasePageControllerState] to design any computation logic
//
// This allow to separate the logic from the view. The controller will notify the Page
// -------------------------------------------------------------
abstract class BasePopingPage<T extends BasePopingPageController> extends StatelessWidget {
  /// page controller as [BasePageController]
  final T pageController;

  /// As [BasePopingPage] always use [WillPopScope], the onWillPop callback is required to build
  ///
  /// It's a callback that will be called whenever the back process is called
  Future<bool> onWillPop() => pageController.onWillPop();

  /// Build the inner content of the page
  Widget getContent(BuildContext context);

  const BasePopingPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: onWillPop,
      child: ChangeNotifierProvider<T>.value(
          value: pageController, child: Consumer<T>(builder: (context, controller, _) => getContent(context))));
}

// -------------------------------------------------------------
// Method described here : Build a page to be used within [PageView]
// - Use a [BasePage] to design UI
// - Use a [BasePageController] with a [BasePageControllerState] to design any computation logic
//
// This allow to separate the logic from the view. The controller will notify the Page
// -------------------------------------------------------------

/// Base class to create a page
abstract class BasePage<T extends BaseViewPageController> extends StatelessWidget {
  const BasePage(this.pageController, {super.key});

  /// It's a callback that will be called whenever the page is hidden
  void onHide() => pageController.onHide();

  /// It's a callback that will be called whenever the page is shown
  void onShow() => pageController.onShow();

  /// Build the inner content of the page
  Widget getContent(BuildContext context);

  // /// method that will be called
  // void onHide();

  /// page controller as [BasePageController]
  final T pageController;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>.value(
      value: pageController, child: Consumer<T>(builder: (context, controller, _) => getContent(context)));
}

/// Controller to hold [BasePage] logic
abstract class BaseViewPageController<T extends BasePageControllerState> extends BasePageController<T> {
  BaseViewPageController(super.stateData);

  /// callback when the page is hidden
  void onHide();

  /// callback when the page is shown
  void onShow();
}

/// Controller to hold [BasePopingPage] logic
abstract class BasePopingPageController<T extends BasePageControllerState> extends BasePageController<T> {
  BasePopingPageController(super.stateData);

  /// As page always use [WillPopScope], the onWillPop callback is required to build a page
  ///
  /// It's a callback that will be called whenever the back process is called
  Future<bool> onWillPop();
}

/// Controller to hold page logic
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
