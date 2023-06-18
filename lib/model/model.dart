import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'model.g.dart';

// Define the 'HotWords' table
const SqfEntityTable tableHotWords = SqfEntityTable(
    tableName: 'hotWord',
    primaryKeyName: 'techId_',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: false,
    objectType: ObjectType.table,
    fields: [
      SqfEntityField('name', DbType.text, isPrimaryKeyField: true, isIndex: true),
      SqfEntityField('value', DbType.text)
    ]);

// Define the 'ListeningSessions' table
const SqfEntityTable tableListeningSessions = SqfEntityTable(
    tableName: 'listeningSession',
    primaryKeyName: 'techId_',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: false,
    objectType: ObjectType.table,
    fields: [
      SqfEntityField('name', DbType.text, isPrimaryKeyField: true, isIndex: true),
      SqfEntityField('label', DbType.text),
      SqfEntityField('duration', DbType.numeric),
      SqfEntityField('isActive', DbType.bool),
      SqfEntityField('rownum', DbType.integer, sequencedBy: seqRowNumber, isIndex: true),
      SqfEntityFieldRelationship(
        parentTable: tableHotWords,
        relationType: RelationType.MANY_TO_MANY,
        deleteRule: DeleteRule.CASCADE,
      )
    ]);

// Define the 'rowNumber' sequence
const SqfEntitySequence seqRowNumber = SqfEntitySequence(
  sequenceName: 'rowNumber',
  maxValue: 10000,
);

// db creation
@SqfEntityBuilder(dbModel)
const SqfEntityModel dbModel = SqfEntityModel(
    modelName: null,
    databaseName: 'guardian_database.db',
    databaseTables: [tableHotWords, tableListeningSessions],
    sequences: [seqRowNumber],
    bundledDatabasePath: null);
