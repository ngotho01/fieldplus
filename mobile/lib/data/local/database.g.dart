// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $JobsTableTable extends JobsTable
    with TableInfo<$JobsTableTable, JobsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _scheduledStartMeta =
      const VerificationMeta('scheduledStart');
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>('scheduled_start', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _scheduledEndMeta =
      const VerificationMeta('scheduledEnd');
  @override
  late final GeneratedColumn<DateTime> scheduledEnd = GeneratedColumn<DateTime>(
      'scheduled_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checklistSchemaMeta =
      const VerificationMeta('checklistSchema');
  @override
  late final GeneratedColumn<String> checklistSchema = GeneratedColumn<String>(
      'checklist_schema', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
      'server_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerName,
        customerPhone,
        address,
        latitude,
        longitude,
        description,
        notes,
        status,
        scheduledStart,
        scheduledEnd,
        checklistSchema,
        serverVersion,
        isSynced,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jobs_table';
  @override
  VerificationContext validateIntegrity(Insertable<JobsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    } else if (isInserting) {
      context.missing(_customerPhoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
          _scheduledStartMeta,
          scheduledStart.isAcceptableOrUnknown(
              data['scheduled_start']!, _scheduledStartMeta));
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('scheduled_end')) {
      context.handle(
          _scheduledEndMeta,
          scheduledEnd.isAcceptableOrUnknown(
              data['scheduled_end']!, _scheduledEndMeta));
    } else if (isInserting) {
      context.missing(_scheduledEndMeta);
    }
    if (data.containsKey('checklist_schema')) {
      context.handle(
          _checklistSchemaMeta,
          checklistSchema.isAcceptableOrUnknown(
              data['checklist_schema']!, _checklistSchemaMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JobsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      scheduledStart: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_start'])!,
      scheduledEnd: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_end'])!,
      checklistSchema: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}checklist_schema']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_version'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JobsTableTable createAlias(String alias) {
    return $JobsTableTable(attachedDatabase, alias);
  }
}

class JobsTableData extends DataClass implements Insertable<JobsTableData> {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final double? latitude;
  final double? longitude;
  final String description;
  final String notes;
  final String status;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final String? checklistSchema;
  final int serverVersion;
  final bool isSynced;
  final DateTime updatedAt;
  const JobsTableData(
      {required this.id,
      required this.customerName,
      required this.customerPhone,
      required this.address,
      this.latitude,
      this.longitude,
      required this.description,
      required this.notes,
      required this.status,
      required this.scheduledStart,
      required this.scheduledEnd,
      this.checklistSchema,
      required this.serverVersion,
      required this.isSynced,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['description'] = Variable<String>(description);
    map['notes'] = Variable<String>(notes);
    map['status'] = Variable<String>(status);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    map['scheduled_end'] = Variable<DateTime>(scheduledEnd);
    if (!nullToAbsent || checklistSchema != null) {
      map['checklist_schema'] = Variable<String>(checklistSchema);
    }
    map['server_version'] = Variable<int>(serverVersion);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JobsTableCompanion toCompanion(bool nullToAbsent) {
    return JobsTableCompanion(
      id: Value(id),
      customerName: Value(customerName),
      customerPhone: Value(customerPhone),
      address: Value(address),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      description: Value(description),
      notes: Value(notes),
      status: Value(status),
      scheduledStart: Value(scheduledStart),
      scheduledEnd: Value(scheduledEnd),
      checklistSchema: checklistSchema == null && nullToAbsent
          ? const Value.absent()
          : Value(checklistSchema),
      serverVersion: Value(serverVersion),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory JobsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobsTableData(
      id: serializer.fromJson<String>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      address: serializer.fromJson<String>(json['address']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      description: serializer.fromJson<String>(json['description']),
      notes: serializer.fromJson<String>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      scheduledEnd: serializer.fromJson<DateTime>(json['scheduledEnd']),
      checklistSchema: serializer.fromJson<String?>(json['checklistSchema']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'address': serializer.toJson<String>(address),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'description': serializer.toJson<String>(description),
      'notes': serializer.toJson<String>(notes),
      'status': serializer.toJson<String>(status),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'scheduledEnd': serializer.toJson<DateTime>(scheduledEnd),
      'checklistSchema': serializer.toJson<String?>(checklistSchema),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JobsTableData copyWith(
          {String? id,
          String? customerName,
          String? customerPhone,
          String? address,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          String? description,
          String? notes,
          String? status,
          DateTime? scheduledStart,
          DateTime? scheduledEnd,
          Value<String?> checklistSchema = const Value.absent(),
          int? serverVersion,
          bool? isSynced,
          DateTime? updatedAt}) =>
      JobsTableData(
        id: id ?? this.id,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        address: address ?? this.address,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        description: description ?? this.description,
        notes: notes ?? this.notes,
        status: status ?? this.status,
        scheduledStart: scheduledStart ?? this.scheduledStart,
        scheduledEnd: scheduledEnd ?? this.scheduledEnd,
        checklistSchema: checklistSchema.present
            ? checklistSchema.value
            : this.checklistSchema,
        serverVersion: serverVersion ?? this.serverVersion,
        isSynced: isSynced ?? this.isSynced,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JobsTableData copyWithCompanion(JobsTableCompanion data) {
    return JobsTableData(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      description:
          data.description.present ? data.description.value : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      scheduledEnd: data.scheduledEnd.present
          ? data.scheduledEnd.value
          : this.scheduledEnd,
      checklistSchema: data.checklistSchema.present
          ? data.checklistSchema.value
          : this.checklistSchema,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobsTableData(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('checklistSchema: $checklistSchema, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      customerName,
      customerPhone,
      address,
      latitude,
      longitude,
      description,
      notes,
      status,
      scheduledStart,
      scheduledEnd,
      checklistSchema,
      serverVersion,
      isSynced,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobsTableData &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.scheduledStart == this.scheduledStart &&
          other.scheduledEnd == this.scheduledEnd &&
          other.checklistSchema == this.checklistSchema &&
          other.serverVersion == this.serverVersion &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class JobsTableCompanion extends UpdateCompanion<JobsTableData> {
  final Value<String> id;
  final Value<String> customerName;
  final Value<String> customerPhone;
  final Value<String> address;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> description;
  final Value<String> notes;
  final Value<String> status;
  final Value<DateTime> scheduledStart;
  final Value<DateTime> scheduledEnd;
  final Value<String?> checklistSchema;
  final Value<int> serverVersion;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JobsTableCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.scheduledEnd = const Value.absent(),
    this.checklistSchema = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JobsTableCompanion.insert({
    required String id,
    required String customerName,
    required String customerPhone,
    required String address,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String description,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    this.checklistSchema = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        customerName = Value(customerName),
        customerPhone = Value(customerPhone),
        address = Value(address),
        description = Value(description),
        scheduledStart = Value(scheduledStart),
        scheduledEnd = Value(scheduledEnd),
        updatedAt = Value(updatedAt);
  static Insertable<JobsTableData> custom({
    Expression<String>? id,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? scheduledStart,
    Expression<DateTime>? scheduledEnd,
    Expression<String>? checklistSchema,
    Expression<int>? serverVersion,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (scheduledEnd != null) 'scheduled_end': scheduledEnd,
      if (checklistSchema != null) 'checklist_schema': checklistSchema,
      if (serverVersion != null) 'server_version': serverVersion,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JobsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? customerName,
      Value<String>? customerPhone,
      Value<String>? address,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String>? description,
      Value<String>? notes,
      Value<String>? status,
      Value<DateTime>? scheduledStart,
      Value<DateTime>? scheduledEnd,
      Value<String?>? checklistSchema,
      Value<int>? serverVersion,
      Value<bool>? isSynced,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return JobsTableCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      checklistSchema: checklistSchema ?? this.checklistSchema,
      serverVersion: serverVersion ?? this.serverVersion,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (scheduledEnd.present) {
      map['scheduled_end'] = Variable<DateTime>(scheduledEnd.value);
    }
    if (checklistSchema.present) {
      map['checklist_schema'] = Variable<String>(checklistSchema.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobsTableCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('checklistSchema: $checklistSchema, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistResponsesTableTable extends ChecklistResponsesTable
    with TableInfo<$ChecklistResponsesTableTable, ChecklistResponsesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistResponsesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
      'job_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responsesMeta =
      const VerificationMeta('responses');
  @override
  late final GeneratedColumn<String> responses = GeneratedColumn<String>(
      'responses', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDraftMeta =
      const VerificationMeta('isDraft');
  @override
  late final GeneratedColumn<bool> isDraft = GeneratedColumn<bool>(
      'is_draft', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_draft" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, jobId, responses, isDraft, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_responses_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChecklistResponsesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
          _jobIdMeta, jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta));
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('responses')) {
      context.handle(_responsesMeta,
          responses.isAcceptableOrUnknown(data['responses']!, _responsesMeta));
    } else if (isInserting) {
      context.missing(_responsesMeta);
    }
    if (data.containsKey('is_draft')) {
      context.handle(_isDraftMeta,
          isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistResponsesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistResponsesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      jobId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_id'])!,
      responses: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}responses'])!,
      isDraft: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_draft'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChecklistResponsesTableTable createAlias(String alias) {
    return $ChecklistResponsesTableTable(attachedDatabase, alias);
  }
}

class ChecklistResponsesTableData extends DataClass
    implements Insertable<ChecklistResponsesTableData> {
  final String id;
  final String jobId;
  final String responses;
  final bool isDraft;
  final DateTime updatedAt;
  const ChecklistResponsesTableData(
      {required this.id,
      required this.jobId,
      required this.responses,
      required this.isDraft,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['responses'] = Variable<String>(responses);
    map['is_draft'] = Variable<bool>(isDraft);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChecklistResponsesTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistResponsesTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      responses: Value(responses),
      isDraft: Value(isDraft),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChecklistResponsesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistResponsesTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      responses: serializer.fromJson<String>(json['responses']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'responses': serializer.toJson<String>(responses),
      'isDraft': serializer.toJson<bool>(isDraft),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChecklistResponsesTableData copyWith(
          {String? id,
          String? jobId,
          String? responses,
          bool? isDraft,
          DateTime? updatedAt}) =>
      ChecklistResponsesTableData(
        id: id ?? this.id,
        jobId: jobId ?? this.jobId,
        responses: responses ?? this.responses,
        isDraft: isDraft ?? this.isDraft,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ChecklistResponsesTableData copyWithCompanion(
      ChecklistResponsesTableCompanion data) {
    return ChecklistResponsesTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      responses: data.responses.present ? data.responses.value : this.responses,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistResponsesTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('responses: $responses, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, jobId, responses, isDraft, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistResponsesTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.responses == this.responses &&
          other.isDraft == this.isDraft &&
          other.updatedAt == this.updatedAt);
}

class ChecklistResponsesTableCompanion
    extends UpdateCompanion<ChecklistResponsesTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> responses;
  final Value<bool> isDraft;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChecklistResponsesTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.responses = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistResponsesTableCompanion.insert({
    required String id,
    required String jobId,
    required String responses,
    this.isDraft = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        jobId = Value(jobId),
        responses = Value(responses),
        updatedAt = Value(updatedAt);
  static Insertable<ChecklistResponsesTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? responses,
    Expression<bool>? isDraft,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (responses != null) 'responses': responses,
      if (isDraft != null) 'is_draft': isDraft,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistResponsesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? jobId,
      Value<String>? responses,
      Value<bool>? isDraft,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChecklistResponsesTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      responses: responses ?? this.responses,
      isDraft: isDraft ?? this.isDraft,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (responses.present) {
      map['responses'] = Variable<String>(responses.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistResponsesTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('responses: $responses, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityId, action, payload, retryCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_table';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final int id;
  final String entityType;
  final String entityId;
  final String action;
  final String payload;
  final int retryCount;
  final DateTime createdAt;
  const SyncQueueTableData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.payload,
      required this.retryCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      payload: Value(payload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueTableData copyWith(
          {int? id,
          String? entityType,
          String? entityId,
          String? action,
          String? payload,
          int? retryCount,
          DateTime? createdAt}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        payload: payload ?? this.payload,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entityType, entityId, action, payload, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String action,
    required String payload,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueTableData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? action,
      Value<String>? payload,
      Value<int>? retryCount,
      Value<DateTime>? createdAt}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PhotosTableTable extends PhotosTable
    with TableInfo<$PhotosTableTable, PhotosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
      'job_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldIdMeta =
      const VerificationMeta('fieldId');
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
      'field_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remoteUrlMeta =
      const VerificationMeta('remoteUrl');
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
      'remote_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _capturedAtMeta =
      const VerificationMeta('capturedAt');
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
      'captured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isUploadedMeta =
      const VerificationMeta('isUploaded');
  @override
  late final GeneratedColumn<bool> isUploaded = GeneratedColumn<bool>(
      'is_uploaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_uploaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        jobId,
        fieldId,
        localPath,
        remoteUrl,
        latitude,
        longitude,
        capturedAt,
        isUploaded
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos_table';
  @override
  VerificationContext validateIntegrity(Insertable<PhotosTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
          _jobIdMeta, jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta));
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(_fieldIdMeta,
          fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta));
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('remote_url')) {
      context.handle(_remoteUrlMeta,
          remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('captured_at')) {
      context.handle(
          _capturedAtMeta,
          capturedAt.isAcceptableOrUnknown(
              data['captured_at']!, _capturedAtMeta));
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('is_uploaded')) {
      context.handle(
          _isUploadedMeta,
          isUploaded.isAcceptableOrUnknown(
              data['is_uploaded']!, _isUploadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotosTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      jobId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_id'])!,
      fieldId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_id'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      remoteUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_url']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      capturedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}captured_at'])!,
      isUploaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_uploaded'])!,
    );
  }

  @override
  $PhotosTableTable createAlias(String alias) {
    return $PhotosTableTable(attachedDatabase, alias);
  }
}

class PhotosTableData extends DataClass implements Insertable<PhotosTableData> {
  final String id;
  final String jobId;
  final String fieldId;
  final String localPath;
  final String? remoteUrl;
  final double? latitude;
  final double? longitude;
  final DateTime capturedAt;
  final bool isUploaded;
  const PhotosTableData(
      {required this.id,
      required this.jobId,
      required this.fieldId,
      required this.localPath,
      this.remoteUrl,
      this.latitude,
      this.longitude,
      required this.capturedAt,
      required this.isUploaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['field_id'] = Variable<String>(fieldId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['is_uploaded'] = Variable<bool>(isUploaded);
    return map;
  }

  PhotosTableCompanion toCompanion(bool nullToAbsent) {
    return PhotosTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      fieldId: Value(fieldId),
      localPath: Value(localPath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      capturedAt: Value(capturedAt),
      isUploaded: Value(isUploaded),
    );
  }

  factory PhotosTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotosTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      isUploaded: serializer.fromJson<bool>(json['isUploaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'fieldId': serializer.toJson<String>(fieldId),
      'localPath': serializer.toJson<String>(localPath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'isUploaded': serializer.toJson<bool>(isUploaded),
    };
  }

  PhotosTableData copyWith(
          {String? id,
          String? jobId,
          String? fieldId,
          String? localPath,
          Value<String?> remoteUrl = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          DateTime? capturedAt,
          bool? isUploaded}) =>
      PhotosTableData(
        id: id ?? this.id,
        jobId: jobId ?? this.jobId,
        fieldId: fieldId ?? this.fieldId,
        localPath: localPath ?? this.localPath,
        remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        capturedAt: capturedAt ?? this.capturedAt,
        isUploaded: isUploaded ?? this.isUploaded,
      );
  PhotosTableData copyWithCompanion(PhotosTableCompanion data) {
    return PhotosTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      capturedAt:
          data.capturedAt.present ? data.capturedAt.value : this.capturedAt,
      isUploaded:
          data.isUploaded.present ? data.isUploaded.value : this.isUploaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotosTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('fieldId: $fieldId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isUploaded: $isUploaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, jobId, fieldId, localPath, remoteUrl,
      latitude, longitude, capturedAt, isUploaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotosTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.fieldId == this.fieldId &&
          other.localPath == this.localPath &&
          other.remoteUrl == this.remoteUrl &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.capturedAt == this.capturedAt &&
          other.isUploaded == this.isUploaded);
}

class PhotosTableCompanion extends UpdateCompanion<PhotosTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> fieldId;
  final Value<String> localPath;
  final Value<String?> remoteUrl;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<DateTime> capturedAt;
  final Value<bool> isUploaded;
  final Value<int> rowid;
  const PhotosTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.isUploaded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosTableCompanion.insert({
    required String id,
    required String jobId,
    required String fieldId,
    required String localPath,
    this.remoteUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required DateTime capturedAt,
    this.isUploaded = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        jobId = Value(jobId),
        fieldId = Value(fieldId),
        localPath = Value(localPath),
        capturedAt = Value(capturedAt);
  static Insertable<PhotosTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? fieldId,
    Expression<String>? localPath,
    Expression<String>? remoteUrl,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? capturedAt,
    Expression<bool>? isUploaded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (fieldId != null) 'field_id': fieldId,
      if (localPath != null) 'local_path': localPath,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (isUploaded != null) 'is_uploaded': isUploaded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? jobId,
      Value<String>? fieldId,
      Value<String>? localPath,
      Value<String?>? remoteUrl,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<DateTime>? capturedAt,
      Value<bool>? isUploaded,
      Value<int>? rowid}) {
    return PhotosTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      fieldId: fieldId ?? this.fieldId,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capturedAt: capturedAt ?? this.capturedAt,
      isUploaded: isUploaded ?? this.isUploaded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (isUploaded.present) {
      map['is_uploaded'] = Variable<bool>(isUploaded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('fieldId: $fieldId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isUploaded: $isUploaded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JobsTableTable jobsTable = $JobsTableTable(this);
  late final $ChecklistResponsesTableTable checklistResponsesTable =
      $ChecklistResponsesTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $PhotosTableTable photosTable = $PhotosTableTable(this);
  late final JobsDao jobsDao = JobsDao(this as AppDatabase);
  late final ChecklistDao checklistDao = ChecklistDao(this as AppDatabase);
  late final SyncDao syncDao = SyncDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [jobsTable, checklistResponsesTable, syncQueueTable, photosTable];
}

typedef $$JobsTableTableCreateCompanionBuilder = JobsTableCompanion Function({
  required String id,
  required String customerName,
  required String customerPhone,
  required String address,
  Value<double?> latitude,
  Value<double?> longitude,
  required String description,
  Value<String> notes,
  Value<String> status,
  required DateTime scheduledStart,
  required DateTime scheduledEnd,
  Value<String?> checklistSchema,
  Value<int> serverVersion,
  Value<bool> isSynced,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$JobsTableTableUpdateCompanionBuilder = JobsTableCompanion Function({
  Value<String> id,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> address,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String> description,
  Value<String> notes,
  Value<String> status,
  Value<DateTime> scheduledStart,
  Value<DateTime> scheduledEnd,
  Value<String?> checklistSchema,
  Value<int> serverVersion,
  Value<bool> isSynced,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$JobsTableTableFilterComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledEnd => $composableBuilder(
      column: $table.scheduledEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checklistSchema => $composableBuilder(
      column: $table.checklistSchema,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JobsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledEnd => $composableBuilder(
      column: $table.scheduledEnd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checklistSchema => $composableBuilder(
      column: $table.checklistSchema,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JobsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledEnd => $composableBuilder(
      column: $table.scheduledEnd, builder: (column) => column);

  GeneratedColumn<String> get checklistSchema => $composableBuilder(
      column: $table.checklistSchema, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JobsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JobsTableTable,
    JobsTableData,
    $$JobsTableTableFilterComposer,
    $$JobsTableTableOrderingComposer,
    $$JobsTableTableAnnotationComposer,
    $$JobsTableTableCreateCompanionBuilder,
    $$JobsTableTableUpdateCompanionBuilder,
    (
      JobsTableData,
      BaseReferences<_$AppDatabase, $JobsTableTable, JobsTableData>
    ),
    JobsTableData,
    PrefetchHooks Function()> {
  $$JobsTableTableTableManager(_$AppDatabase db, $JobsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JobsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> scheduledStart = const Value.absent(),
            Value<DateTime> scheduledEnd = const Value.absent(),
            Value<String?> checklistSchema = const Value.absent(),
            Value<int> serverVersion = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JobsTableCompanion(
            id: id,
            customerName: customerName,
            customerPhone: customerPhone,
            address: address,
            latitude: latitude,
            longitude: longitude,
            description: description,
            notes: notes,
            status: status,
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            checklistSchema: checklistSchema,
            serverVersion: serverVersion,
            isSynced: isSynced,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String customerName,
            required String customerPhone,
            required String address,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            required String description,
            Value<String> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime scheduledStart,
            required DateTime scheduledEnd,
            Value<String?> checklistSchema = const Value.absent(),
            Value<int> serverVersion = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              JobsTableCompanion.insert(
            id: id,
            customerName: customerName,
            customerPhone: customerPhone,
            address: address,
            latitude: latitude,
            longitude: longitude,
            description: description,
            notes: notes,
            status: status,
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            checklistSchema: checklistSchema,
            serverVersion: serverVersion,
            isSynced: isSynced,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JobsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JobsTableTable,
    JobsTableData,
    $$JobsTableTableFilterComposer,
    $$JobsTableTableOrderingComposer,
    $$JobsTableTableAnnotationComposer,
    $$JobsTableTableCreateCompanionBuilder,
    $$JobsTableTableUpdateCompanionBuilder,
    (
      JobsTableData,
      BaseReferences<_$AppDatabase, $JobsTableTable, JobsTableData>
    ),
    JobsTableData,
    PrefetchHooks Function()>;
typedef $$ChecklistResponsesTableTableCreateCompanionBuilder
    = ChecklistResponsesTableCompanion Function({
  required String id,
  required String jobId,
  required String responses,
  Value<bool> isDraft,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ChecklistResponsesTableTableUpdateCompanionBuilder
    = ChecklistResponsesTableCompanion Function({
  Value<String> id,
  Value<String> jobId,
  Value<String> responses,
  Value<bool> isDraft,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ChecklistResponsesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistResponsesTableTable> {
  $$ChecklistResponsesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobId => $composableBuilder(
      column: $table.jobId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get responses => $composableBuilder(
      column: $table.responses, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDraft => $composableBuilder(
      column: $table.isDraft, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ChecklistResponsesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistResponsesTableTable> {
  $$ChecklistResponsesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobId => $composableBuilder(
      column: $table.jobId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get responses => $composableBuilder(
      column: $table.responses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDraft => $composableBuilder(
      column: $table.isDraft, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChecklistResponsesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistResponsesTableTable> {
  $$ChecklistResponsesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jobId =>
      $composableBuilder(column: $table.jobId, builder: (column) => column);

  GeneratedColumn<String> get responses =>
      $composableBuilder(column: $table.responses, builder: (column) => column);

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChecklistResponsesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistResponsesTableTable,
    ChecklistResponsesTableData,
    $$ChecklistResponsesTableTableFilterComposer,
    $$ChecklistResponsesTableTableOrderingComposer,
    $$ChecklistResponsesTableTableAnnotationComposer,
    $$ChecklistResponsesTableTableCreateCompanionBuilder,
    $$ChecklistResponsesTableTableUpdateCompanionBuilder,
    (
      ChecklistResponsesTableData,
      BaseReferences<_$AppDatabase, $ChecklistResponsesTableTable,
          ChecklistResponsesTableData>
    ),
    ChecklistResponsesTableData,
    PrefetchHooks Function()> {
  $$ChecklistResponsesTableTableTableManager(
      _$AppDatabase db, $ChecklistResponsesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistResponsesTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistResponsesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistResponsesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> jobId = const Value.absent(),
            Value<String> responses = const Value.absent(),
            Value<bool> isDraft = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistResponsesTableCompanion(
            id: id,
            jobId: jobId,
            responses: responses,
            isDraft: isDraft,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String jobId,
            required String responses,
            Value<bool> isDraft = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistResponsesTableCompanion.insert(
            id: id,
            jobId: jobId,
            responses: responses,
            isDraft: isDraft,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistResponsesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChecklistResponsesTableTable,
        ChecklistResponsesTableData,
        $$ChecklistResponsesTableTableFilterComposer,
        $$ChecklistResponsesTableTableOrderingComposer,
        $$ChecklistResponsesTableTableAnnotationComposer,
        $$ChecklistResponsesTableTableCreateCompanionBuilder,
        $$ChecklistResponsesTableTableUpdateCompanionBuilder,
        (
          ChecklistResponsesTableData,
          BaseReferences<_$AppDatabase, $ChecklistResponsesTableTable,
              ChecklistResponsesTableData>
        ),
        ChecklistResponsesTableData,
        PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<int> id,
  required String entityType,
  required String entityId,
  required String action,
  required String payload,
  Value<int> retryCount,
  required DateTime createdAt,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> action,
  Value<String> payload,
  Value<int> retryCount,
  Value<DateTime> createdAt,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required String entityId,
            required String action,
            required String payload,
            Value<int> retryCount = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()>;
typedef $$PhotosTableTableCreateCompanionBuilder = PhotosTableCompanion
    Function({
  required String id,
  required String jobId,
  required String fieldId,
  required String localPath,
  Value<String?> remoteUrl,
  Value<double?> latitude,
  Value<double?> longitude,
  required DateTime capturedAt,
  Value<bool> isUploaded,
  Value<int> rowid,
});
typedef $$PhotosTableTableUpdateCompanionBuilder = PhotosTableCompanion
    Function({
  Value<String> id,
  Value<String> jobId,
  Value<String> fieldId,
  Value<String> localPath,
  Value<String?> remoteUrl,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<DateTime> capturedAt,
  Value<bool> isUploaded,
  Value<int> rowid,
});

class $$PhotosTableTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTableTable> {
  $$PhotosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobId => $composableBuilder(
      column: $table.jobId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteUrl => $composableBuilder(
      column: $table.remoteUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnFilters(column));
}

class $$PhotosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTableTable> {
  $$PhotosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobId => $composableBuilder(
      column: $table.jobId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
      column: $table.remoteUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnOrderings(column));
}

class $$PhotosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTableTable> {
  $$PhotosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jobId =>
      $composableBuilder(column: $table.jobId, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => column);

  GeneratedColumn<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => column);
}

class $$PhotosTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhotosTableTable,
    PhotosTableData,
    $$PhotosTableTableFilterComposer,
    $$PhotosTableTableOrderingComposer,
    $$PhotosTableTableAnnotationComposer,
    $$PhotosTableTableCreateCompanionBuilder,
    $$PhotosTableTableUpdateCompanionBuilder,
    (
      PhotosTableData,
      BaseReferences<_$AppDatabase, $PhotosTableTable, PhotosTableData>
    ),
    PhotosTableData,
    PrefetchHooks Function()> {
  $$PhotosTableTableTableManager(_$AppDatabase db, $PhotosTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> jobId = const Value.absent(),
            Value<String> fieldId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String?> remoteUrl = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<DateTime> capturedAt = const Value.absent(),
            Value<bool> isUploaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotosTableCompanion(
            id: id,
            jobId: jobId,
            fieldId: fieldId,
            localPath: localPath,
            remoteUrl: remoteUrl,
            latitude: latitude,
            longitude: longitude,
            capturedAt: capturedAt,
            isUploaded: isUploaded,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String jobId,
            required String fieldId,
            required String localPath,
            Value<String?> remoteUrl = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            required DateTime capturedAt,
            Value<bool> isUploaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotosTableCompanion.insert(
            id: id,
            jobId: jobId,
            fieldId: fieldId,
            localPath: localPath,
            remoteUrl: remoteUrl,
            latitude: latitude,
            longitude: longitude,
            capturedAt: capturedAt,
            isUploaded: isUploaded,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotosTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhotosTableTable,
    PhotosTableData,
    $$PhotosTableTableFilterComposer,
    $$PhotosTableTableOrderingComposer,
    $$PhotosTableTableAnnotationComposer,
    $$PhotosTableTableCreateCompanionBuilder,
    $$PhotosTableTableUpdateCompanionBuilder,
    (
      PhotosTableData,
      BaseReferences<_$AppDatabase, $PhotosTableTable, PhotosTableData>
    ),
    PhotosTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JobsTableTableTableManager get jobsTable =>
      $$JobsTableTableTableManager(_db, _db.jobsTable);
  $$ChecklistResponsesTableTableTableManager get checklistResponsesTable =>
      $$ChecklistResponsesTableTableTableManager(
          _db, _db.checklistResponsesTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$PhotosTableTableTableManager get photosTable =>
      $$PhotosTableTableTableManager(_db, _db.photosTable);
}

mixin _$ChecklistDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChecklistResponsesTableTable get checklistResponsesTable =>
      attachedDatabase.checklistResponsesTable;
}
mixin _$SyncDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
}
