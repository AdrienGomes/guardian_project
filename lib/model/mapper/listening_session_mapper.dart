import 'package:guardian_project/model/mapper/base_mapper.dart';
import 'package:guardian_project/model/mapper/hot_word_mapper.dart';
import 'package:guardian_project/model/model.dart';
import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:uuid/uuid.dart';

/// Mapper class for [ListeningSessionModelObject] and [ListeningSession]
class ListeningSessionMapper extends Mapper<ListeningSessionModelObject, ListeningSession> {
  /// ctor
  ListeningSessionMapper([Map<int, ModelObject>? alreadyMappedModelObject, Map<int, TableBase>? alreadyMappedTable])
      : super(alreadyMappedModelObject ?? {}, alreadyMappedTable ?? {});

  @override
  ListeningSession toBaseTable(ListeningSessionModelObject modelObject) {
    // avoid infinite loop
    if (alreadyMappedTable.containsKey(modelObject.techId_)) {
      return alreadyMappedTable[modelObject.techId_] as ListeningSession;
    }

    // fill fields
    final table = ListeningSession()
      ..label = modelObject.label
      ..techId_ = modelObject.techId_
      ..duration = modelObject.duration?.inSeconds
      ..isActive = modelObject.isActive
      ..name = modelObject.name;

    alreadyMappedTable[modelObject.techId_] = table;

    // fill relations
    table.plHotWords = modelObject.hotWords
            ?.map((ls) => HotWordMapper(alreadyMappedModelObject, alreadyMappedTable).toBaseTable(ls))
            .toList() ??
        [];
    return table;
  }

  @override
  ListeningSessionModelObject toModelObject(ListeningSession table) {
    // avoid infinite loop
    if (alreadyMappedTable.containsKey(table.techId_)) {
      return alreadyMappedModelObject[table.techId_] as ListeningSessionModelObject;
    }

    // fill fields
    final modelObject = ListeningSessionModelObject.empty()
      ..techId_ = table.techId_ ?? const Uuid().v4().hashCode
      ..name = table.name ?? const Uuid().v4()
      ..isActive = table.isActive
      ..duration = table.duration == null ? null : Duration(seconds: table.duration!)
      ..label = table.label;

    alreadyMappedModelObject[modelObject.techId_] = modelObject;

    // fill relations
    modelObject.hotWords = table.plHotWords
            ?.map((ls) => HotWordMapper(alreadyMappedModelObject, alreadyMappedTable).toModelObject(ls))
            .toList() ??
        [];
    return modelObject;
  }
}
