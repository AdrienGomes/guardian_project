import 'package:guardian_project/model/mapper/listening_session_mapper.dart';
import 'package:guardian_project/model/model.dart';
import 'package:guardian_project/model/model_object/hot_word_model_object.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';
import 'package:guardian_project/service/db_client_service.dart';

import 'base_repository.dart';

/// Repository to communicate with the [ListeningSession] table from the DB model
class ListeningSessionRepository extends Repository<ListeningSessionModelObject> {
  ListeningSessionRepository(super.dbClientService);

  @override
  Future<void> saveAsync(ListeningSessionModelObject modelObject, DBTransaction transaction) async {
    /// can't update twice the same model object
    if (transaction.getModelObject(modelObject) != null) return;

    /// turn the [ModelObject] into [BaseTable]
    final table = ListeningSessionMapper().toBaseTable(modelObject);

    // saving/updating [ListeningSessionModelObject]
    var saveResult = await table.save(ignoreBatch: false);

    // checking for success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }

    /// register object to transaction
    transaction.registerModelObject(modelObject);

    // creating relation's entries
    if (table.plHotWords != null) {
      for (final hw in modelObject.hotWords!) {
        // save/update [HotWordModelObject]
        await dbClientService.saveToDb(hw, transaction);

        // adding entries in the cross tables
        saveResult = await ListeningSessionHotWord(
                hotWordTechId_: hw.techId_,
                listeningSessionTechId_: table.techId_,
                hotWordName: hw.name,
                listeningSessionName: table.name)
            .save();

        // checking for success
        if (!saveResult.success) {
          throw Exception(saveResult.errorMessage);
        }
      }
    }
  }

  @override
  Future<List<ListeningSessionModelObject>> searchAsync(String? whereClause,
      {List<String> sortAxes = const [], int pageSize = 10, int pageNumber = 0}) async {
    /// retieves fields
    final tables =
        (await ListeningSession().select().where(whereClause).orderBy(sortAxes).page(pageNumber, pageSize).toList());

    /// retieves relations
    return await Future.wait(tables
        .map((hw) async => ListeningSessionMapper().toModelObject(hw..plHotWords = await hw.getHotWords()?.toList()))
        .toList());
  }

  @override
  Future<void> saveList(List<ListeningSessionModelObject> modelObjects, DBTransaction transaction) async {
    /// can't update twice the same model object
    if (modelObjects.any((mo) => transaction.getModelObject(mo) != null)) return;

    /// turn the [ModelObject]s into [BaseTable]s
    final tables = modelObjects.map((mo) => ListeningSessionMapper().toBaseTable(mo)).toList();
    final List<HotWordModelObject> hotWordModelObjects = [];
    final List<ListeningSessionHotWord> listeiningSessionHotWordTable = [];

    // saving/updating [ListeningSessionModelObject]
    var saveResult = await ListeningSession().upsertAll(tables);

    // checking for success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }

    /// register object to transaction
    for (final mo in modelObjects) {
      transaction.registerModelObject(mo);

      // creating relation's entries
      if (mo.hotWords != null) {
        for (final hw in mo.hotWords!) {
          /// skip hotWord already treated
          if (transaction.getModelObject(hw) == null) {
            hotWordModelObjects.add(hw);
          }

          // adding entries in the cross tables
          listeiningSessionHotWordTable.add(ListeningSessionHotWord(
              hotWordTechId_: hw.techId_,
              listeningSessionTechId_: mo.techId_,
              hotWordName: hw.name,
              listeningSessionName: mo.name));
        }
      }
    }

    /// save list of hotWords
    await dbClientService.saveToDbAsList(hotWordModelObjects);

    /// save cross table
    saveResult = await ListeningSessionHotWord().upsertAll(listeiningSessionHotWordTable);

    // checking for success
    if (!saveResult.success) {
      throw Exception(saveResult.errorMessage);
    }
  }
}
