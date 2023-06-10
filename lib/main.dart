import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/generated/l10n.dart';
import 'package:guardian_project/intl.dart';
import 'package:guardian_project/pages/home_page/home_page.dart';
import 'package:guardian_project/pages/sound_configuration/sound_configuration_page.dart';
import 'package:guardian_project/service_locator.dart';
import 'package:guardian_project/theme/theme.dart';

// global navigator key
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// the dispatcher to be called as a new entry point function by the [WorkmanagerService]
///
/// Must be either a top level function or a static function
@pragma('vm:entry-point')
void Function()? callbackDispatcher;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // init dependency injection
  ServiceLocator.init();

  // TODO : Create a logging service
  // FlutterError.onError = (details) {
  //   FlutterError.presentError(details);
  //   serviceLocator<ToastService>().showToast(details.exception.toString(), criticity: ToastCriticity.error);
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   serviceLocator<ToastService>().showToast(error.toString(), criticity: ToastCriticity.error);
  //   return true;
  // };

  // run app
  runApp(const GuardianApp());
}

class GuardianApp extends StatelessWidget {
  const GuardianApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian App',
      theme: GuardianTheme().theme,
      darkTheme: GuardianTheme(darkMode: true).theme,
      home: const NavigationBottomBar(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
    );
  }
}

/// navigator class to build the navigation menu
class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key});

  @override
  State<NavigationBottomBar> createState() => _StateNavigationBottomBar();
}

class _StateNavigationBottomBar extends State<NavigationBottomBar> with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  late final List<NavigationEntry> _navigationEntries;
  late PageController _pageController;

  static const animationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _navigationEntries = _getNavigationEntries();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _navigationEntries.map((e) => e.destinationBuilder).toList()),
        bottomNavigationBar: _getNavigationBar(),
      );

  /// Get the [NavigationBar]
  Widget _getNavigationBar() => BottomNavigationBar(
        items: _navigationEntries.map((e) => e.navigationBarItem).toList(),
        currentIndex: _pageIndex,
        onTap: _navigate,
      );

  /// navigate to the selected page
  void _navigate(int pageIndex) => setState(() {
        _pageController.animateToPage(pageIndex, duration: animationDuration, curve: Curves.fastOutSlowIn);
      });

  /// callback called when the page is changed
  void _onPageChanged(int pageIndex) {
    _navigationEntries[_pageIndex].destinationBuilder.onHide();
    _navigationEntries[pageIndex].destinationBuilder.onShow();
    setState(() => _pageIndex = pageIndex);
  }

  /// get all the [NavigationEntry] for the application
  List<NavigationEntry> _getNavigationEntries() => [
        _buildNavigationEntry(destinationPage: HomePage(), title: tr.app_bar_title_home_page, icon: Icons.safety_check),
        _buildNavigationEntry(
            destinationPage: SoundConfigurationPage(),
            title: tr.app_bar_title_sound_configuration_page,
            icon: Icons.equalizer)
      ];

  /// builds a single navigation bar entry ([NavigationEntry])
  NavigationEntry _buildNavigationEntry(
          {required BasePage destinationPage,
          required String title,
          required IconData icon,
          Color? iconColor,
          Color? backgroundColor}) =>
      NavigationEntry(
          destinationBuilder: destinationPage,
          navigationBarItem: BottomNavigationBarItem(
              label: title, icon: Icon(icon, color: iconColor), backgroundColor: backgroundColor),
          title: title);
}

/// Hold information about a navigation entry
///
/// To use with [NavigationBar]
class NavigationEntry {
  final BasePage destinationBuilder;
  final BottomNavigationBarItem navigationBarItem;
  final String title;

  const NavigationEntry({required this.destinationBuilder, required this.navigationBarItem, required this.title});
}
