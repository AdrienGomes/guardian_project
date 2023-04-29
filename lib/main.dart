import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardian_project/common/base_page.dart';
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
      home: const NavigatorHomeScreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
    );
  }
}

/// navigator class to build the navigation menu
class NavigatorHomeScreen extends StatefulWidget {
  const NavigatorHomeScreen({super.key});

  @override
  State<NavigatorHomeScreen> createState() => _StateNavigatorHomeScreen();
}

class _StateNavigatorHomeScreen extends State<NavigatorHomeScreen> with SingleTickerProviderStateMixin {
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
          children: _navigationEntries.map((e) => e.destinationBuilder()).toList(),
          onPageChanged: (pageIndex) => setState(() => _pageIndex = pageIndex),
        ),
        bottomNavigationBar: _getNavigationBar(),
      );

  /// Get the [NavigationBar]
  Widget _getNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _navigationEntries.map((e) => e.navigationBarItem).toList(),
        currentIndex: _pageIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _navigate,
      );

  /// navigate to the selected page
  void _navigate(int pageIndex) => setState(() {
        _pageIndex = pageIndex;
        _pageController.animateToPage(_pageIndex, duration: animationDuration, curve: Curves.fastOutSlowIn);
      });

  /// get all the [NavigationEntry] for the application
  List<NavigationEntry> _getNavigationEntries() => [
        _buildNavigationEntry(destinationBuilder: HomePage(), title: "Home Page", icon: Icons.safety_check),
        _buildNavigationEntry(
            destinationBuilder: SoundConfigurationPage(), title: "Sound Configuration", icon: Icons.equalizer)
      ];

  /// builds a single navigation bar entry ([NavigationEntry])
  NavigationEntry _buildNavigationEntry(
          {required BasePage destinationBuilder,
          required String title,
          required IconData icon,
          Color? iconColor,
          Color? backgroundColor}) =>
      NavigationEntry(
          destinationBuilder: () => destinationBuilder,
          navigationBarItem: BottomNavigationBarItem(
              label: title, icon: Icon(icon, color: iconColor), backgroundColor: backgroundColor),
          title: title);
}

/// Hold information about a navigation entry
///
/// To use with [NavigationBar]
class NavigationEntry {
  final BasePage Function() destinationBuilder;
  final BottomNavigationBarItem navigationBarItem;
  final String title;

  const NavigationEntry({required this.destinationBuilder, required this.navigationBarItem, required this.title});
}
