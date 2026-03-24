part of '../database.dart';

class JobsTable extends Table {
  TextColumn get id            => text()();
  TextColumn get customerName  => text()();
  TextColumn get customerPhone => text()();
  TextColumn get address       => text()();
  RealColumn get latitude      => real().nullable()();
  RealColumn get longitude     => real().nullable()();
  TextColumn get description   => text()();
  TextColumn get notes         => text().withDefault(const Constant(''))();
  TextColumn get status        => text().withDefault(const Constant('pending'))();
  DateTimeColumn get scheduledStart => dateTime()();
  DateTimeColumn get scheduledEnd   => dateTime()();
  TextColumn get checklistSchema    => text().nullable()(); // JSON string
  IntColumn  get serverVersion      => integer().withDefault(const Constant(1))();
  BoolColumn get isSynced           => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt      => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}