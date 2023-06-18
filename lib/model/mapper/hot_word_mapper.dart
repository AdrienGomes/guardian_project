import 'package:guardian_project/model/mapper/base_mapper.dart';
import 'package:guardian_project/model/mapper/listening_session_mapper.dart';
import 'package:guardian_project/model/model.dart';
import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/model/model_object/hot_word_model_object.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:uuid/uuid.dart';

/// Mapper class for [HotWordModelObject] and [HotWord]
class HotWordMapper extends Mapper<HotWordModelObject, HotWord> {
  /// ctor
  HotWordMapper([Map<int, ModelObject>? alreadyMappedModelObject, Map<int, TableBase>? alreadyMappedTable])
      : super(alreadyMappedModelObject ?? {}, alreadyMappedTable ?? {});

  @override
  HotWord toBaseTable(HotWordModelObject modelObject) {
    // avoid infinite loop
    if (alreadyMappedTable.containsKey(modelObject.techId_)) return alreadyMappedTable[modelObject.techId_] as HotWord;

    // fill fields
    final table = HotWord()
      ..value = modelObject.value
      ..techId_ = modelObject.techId_
      ..name = modelObject.name;

    alreadyMappedTable[modelObject.techId_] = table;

// fill relations
    table.plListeningSessions = modelObject.listeningSessions
            ?.map((ls) => ListeningSessionMapper(alreadyMappedModelObject, alreadyMappedTable).toBaseTable(ls))
            .toList() ??
        [];
    return table;
  }

  @override
  HotWordModelObject toModelObject(HotWord table) {
    // avoid infinite loop
    if (alreadyMappedTable.containsKey(table.techId_)) {
      return alreadyMappedModelObject[table.techId_] as HotWordModelObject;
    }

    // fill fields
    final modelObject = HotWordModelObject.empty()
      ..techId_ = table.techId_ ?? const Uuid().v4().hashCode
      ..name = table.name ?? const Uuid().v4()
      ..value = table.value;

    alreadyMappedModelObject[modelObject.techId_] = modelObject;

    // fill relations
    modelObject.listeningSessions = table.plListeningSessions
            ?.map((ls) => ListeningSessionMapper(alreadyMappedModelObject, alreadyMappedTable).toModelObject(ls))
            .toList() ??
        [];
    return modelObject;
  }
}
