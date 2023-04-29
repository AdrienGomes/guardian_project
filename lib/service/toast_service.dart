import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardian_project/common/widget/toast_widget.dart';

/// Toast service to show custom toast
class ToastService {
  final FToast _toaster;
  final GlobalKey<NavigatorState> _navigatorKey;

  BuildContext? _context;

  /// get the duration of a toast
  static Duration _getToastDuration(bool isLongToast) =>
      isLongToast ? const Duration(seconds: 8) : const Duration(seconds: 4);

  ToastService.init(this._navigatorKey) : _toaster = FToast();

  /// triggers a toast
  void showToast(String message,
      {String? title, ToastCriticity criticity = ToastCriticity.info, bool isLongToast = false}) {
    if (_context == null) {
      _context = _navigatorKey.currentContext;
      _toaster.init(_context!);
    }
    _toaster.showToast(
        child: CustomToast(message: ToastMessage(title: title, message: message, criticity: criticity)),
        gravity: ToastGravity.BOTTOM,
        fadeDuration: const Duration(milliseconds: 100),
        toastDuration: _getToastDuration(isLongToast));
  }

  /// remove a toast
  void dismissToast() => _toaster.removeCustomToast();
}

/// Toast message
class ToastMessage {
  final String message;
  final String? title;
  final ToastCriticity criticity;

  const ToastMessage({this.title, required this.message, this.criticity = ToastCriticity.info});
}

/// Toast criticity
enum ToastCriticity { info, warning, error }
