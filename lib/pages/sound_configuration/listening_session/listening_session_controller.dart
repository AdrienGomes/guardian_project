import 'package:guardian_project/common/base_async_state.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/model/model_object/hot_word_model_object.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';
import 'package:guardian_project/service/db_client_service.dart';
import 'package:guardian_project/service_locator.dart';

/// ## [ListeningSessionPage] controller
class ListeningSessionPageController extends BasePopingPageController<_StateListeningSessionPageController> {
  ListeningSessionPageController() : super(_StateListeningSessionPageController());

  /// db client to communicate with the DB
  final DbClientService _dbClient = serviceLocator<DbClientService>();

  @override
  void initAsync() async {
    /// loading data from db
    await _loadDataFromDb();
  }

  /// set the active listeining session
  void setActiveListeningSession(int index) {
    // turn isActive to false for the old active session
    final oldLs = stateData._activeListeningSession;
    oldLs?.isActive = false;

    // turn isActive to true for the new active session
    stateData._activeListeningSession = stateData._listeningSessions.elementAt(index);
    stateData._activeListeningSession?.isActive = true;

    // saving both listening sessions
    _dbClient.saveToDbAsList(
        oldLs == null ? [stateData._activeListeningSession!] : [oldLs, stateData._activeListeningSession!]);
    notifyListeners();
  }

  /// add a listening session to db
  Future<void> addListeningSession() async {
    final name = _buildUniqueListeningSessionName();
    final lsObject = ListeningSessionModelObject.empty()
      ..name = name
      ..label = name;

    lsObject.hotWords?.addAll([
      HotWordModelObject.empty()
        ..listeningSessions?.add(lsObject)
        ..value = "hotWord1"
        ..name = "hotWord1",
      HotWordModelObject.empty()
        ..listeningSessions?.add(lsObject)
        ..value = "hotWord2"
        ..name = "hotWord2"
    ]);

    /// save to db
    await _dbClient.saveToDb(lsObject);

    await _loadDataFromDb();
  }

  /// build a unique listening session name
  String _buildUniqueListeningSessionName() {
    int identifier = 0;

    while (stateData._listeningSessions.any((ls) => ls.name == "listening_session$identifier")) {
      identifier++;
    }

    return "listening_session$identifier";
  }

  /// loads data from DB
  Future<void> _loadDataFromDb() async {
    /// retrieving active listening sessions
    stateData._listeningSessions = await _dbClient.getItems();
    if (stateData._listeningSessions.isNotEmpty) {
      stateData._activeListeningSession = stateData._listeningSessions
          .firstWhere((ls) => ls.isActive == true, orElse: () => stateData._listeningSessions.first);
    }
    notifyListeners();
  }

  @override
  Future<bool> onWillPop() => Future.value(!stateData.isBusy);
}

class _StateListeningSessionPageController extends BasePageControllerState {
  /// hold the list of listening sessions
  List<ListeningSessionModelObject> get listeningSessions => _listeningSessions;
  List<ListeningSessionModelObject> _listeningSessions = [];

  /// hold the list of listening sessions
  ListeningSessionModelObject? get activeListeningSession => _activeListeningSession;
  ListeningSessionModelObject? _activeListeningSession;
}
