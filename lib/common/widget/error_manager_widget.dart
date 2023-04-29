import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/theme/theme.dart';
import 'package:provider/provider.dart';

/// A widget to display error
///
/// Need to be used within a [ChangeNotifierProvider] derived widget
class ErrorManager extends StatelessWidget{
  final bool asToast;

  const ErrorManager({super.key, this.asToast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ErrorManagerThemeExtension>();
    return Consumer<BasePageController>(builder: (context, controller,_) => !asToast ? Container(
      decoration: BoxDecoration(color: theme?.backgroundColor),
      width: theme?.width,
      height: theme?.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Row(children: const [
            Icon(Icons.error),
            Expanded(child:Text("Error"))
            ]
           ),
          Expanded(child: SelectableText(controller.stateData.getFormattedError()))
        ],
      ),

    ) : const SizedBox(),
    );
  }

}