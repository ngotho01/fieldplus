part of '../database.dart';

class PhotosTable extends Table {
  TextColumn get id        => text()();
  TextColumn get jobId     => text()();
  TextColumn get fieldId   => text()();
  TextColumn get localPath => text()();
  TextColumn get remoteUrl => text().nullable()();
  RealColumn get latitude  => real().nullable()();
  RealColumn get longitude => real().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  BoolColumn get isUploaded     => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}