part of '../database.dart';

class SyncQueueTable extends Table {
  IntColumn  get id         => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId   => text()();
  TextColumn get action     => text()();
  TextColumn get payload    => text()();
  IntColumn  get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}