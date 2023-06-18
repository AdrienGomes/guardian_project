import 'package:guardian_project/model/mapper/hot_word_mapper.dart';
import 'package:guardian_project/model/model.dart';
import 'package:guardian_project/model/model_object/hot_word_model_object.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';
import 'package:guardian_project/service/db_client_service.dart';

import 'base_repository.dart';

/// Repository to communicate with the [HotWord] table from the DB model
class HotWordRepository extends Repository<HotWordModelObject> {
  HotWordRepository(super.dbClientService);

  @override
  Future<void> saveAsync(HotWordModelObject modelObject, DBTransaction transaction) async {
    /// can't update twice the same model object
    if (transaction.getModelObject(modelObject) != null) return;

    /// turn the [ModelObject] into [BaseTable]
    final table = HotWordMapper().toBaseTable(modelObject);

    // saving/updating [HotWordModelObject]
    final saveResult = await table.save(ignoreBatch: false);

    /// register object to transaction as already treated
    transaction.registerModelObject(modelObject);

    // building entries for relations
    if (table.plListeningSessions != null) {
      for (final ls in modelObject.listeningSessions!) {
        // save/update [ListeningSessionModelObject]
        await dbClientService.saveToDb(ls, transaction);

        // adding entries in the cross tables
        saveResult.success &= (await ListeningSessionHotWord(
                    hotWordTechId_: table.techId_,
                    listeningSessionTechId_: ls.techId_,
                    hotWordName: table.name,
                    listeningSessionName: ls.name)
                .save())
            .success;
      }
    }

    // checking for step success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }
  }

  @override
  Future<List<HotWordModelObject>> searchAsync(String? whereClause,
      {List<String> sortAxes = const [], int pageSize = 10, int pageNumber = 0}) async {
    /// retrieves fields
    final tables = (await HotWord().select().where(whereClause).orderBy(sortAxes).page(pageNumber, pageSize).toList());

    /// retrieves relations
    return await Future.wait(tables
        .map((hw) async =>
            HotWordMapper().toModelObject(hw..plListeningSessions = await hw.getListeningSessions()?.toList()))
        .toList());
  }

  @override
  Future<void> saveList(List<HotWordModelObject> modelObjects, DBTransaction transaction) async {
    /// can't update twice the same model object
    if (modelObjects.any((mo) => transaction.getModelObject(mo) != null)) return;

    /// turn [ModelObject]s into [BaseTable]s
    final tables = modelObjects.map((mo) => HotWordMapper().toBaseTable(mo)).toList();
    final List<ListeningSessionModelObject> listeningSessionModelObjects = [];
    final List<ListeningSessionHotWord> listeiningSessionHotWordTable = [];

    // saving/updating [HotWordModelObject]
    var saveResult = await HotWord().upsertAll(tables);

    // checking for success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }

    /// register object to transaction
    for (final ls in modelObjects) {
      transaction.registerModelObject(ls);

      // creating relation's entries
      if (ls.listeningSessions != null) {
        for (final hw in ls.listeningSessions!) {
          /// skip hotWord already treated
          if (transaction.getModelObject(hw) == null) {
            listeningSessionModelObjects.add(hw);
          }

          // adding entries in the cross tables
          listeiningSessionHotWordTable.add(ListeningSessionHotWord(
              hotWordTechId_: hw.techId_,
              listeningSessionTechId_: ls.techId_,
              hotWordName: hw.name,
              listeningSessionName: ls.name));
        }
      }
    }

    /// save list of [ListeningSessionModelObject] associated with the hotWords
    await dbClientService.saveToDbAsList(listeningSessionModelObjects);

    /// save cross table
    saveResult = await ListeningSessionHotWord().upsertAll(listeiningSessionHotWordTable);

    // checking for success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }
  }
}
