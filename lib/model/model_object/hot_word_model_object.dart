import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';

/// Hold information about a hotWord
class HotWordModelObject extends ModelObject {
  /// the value of the hot word
  String? value = "";

  /// [ListeningSessionModelObject] using this hot word as relation
  List<ListeningSessionModelObject>? listeningSessions = [];

  /// empty ctor
  HotWordModelObject.empty() : super.empty();
}
