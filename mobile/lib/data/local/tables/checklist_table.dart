part of '../database.dart';

class ChecklistResponsesTable extends Table {
  TextColumn get id        => text()();
  TextColumn get jobId     => text()();
  TextColumn get responses => text()(); // JSON string
  BoolColumn get isDraft   => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}