import 'package:flutter/material.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:guardian_project/service_locator.dart';
import 'package:guardian_project/theme/guardian_theme_color.dart';

class CustomToast extends StatelessWidget {
  final ToastMessage message;

  static const Duration toastAnimationDuration = Duration(milliseconds: 200);
  static const SizedBox widthSpace = SizedBox(
    width: 10,
  );

  const CustomToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GestureDetector(
            onTap: () => serviceLocator<ToastService>().dismissToast(),
            child: AnimatedContainer(
              duration: toastAnimationDuration,
              height: 37,
              width: MediaQuery.of(context).size.width - 120,
              decoration: BoxDecoration(
                  color: _getToastColor(message).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 3, blurRadius: 2)]),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _getToastIcon(message),
                    ),
                    widthSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.title != null)
                            Text(
                              message.title!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          Expanded(
                            child: Text(
                              message.message,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ],
      );

  /// get toast color
  Color _getToastColor(ToastMessage message) => message.criticity == ToastCriticity.error
      ? GuardianThemeColor.errorToastColor
      : message.criticity == ToastCriticity.warning
          ? GuardianThemeColor.warningToastColor
          : GuardianThemeColor.infoToastColor;

  /// get toast icon
  Icon _getToastIcon(ToastMessage message) => Icon(message.criticity == ToastCriticity.error
      ? Icons.error
      : message.criticity == ToastCriticity.warning
          ? Icons.warning
          : Icons.info);
}
