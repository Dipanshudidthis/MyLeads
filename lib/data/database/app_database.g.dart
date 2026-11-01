// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LeadListsTable extends LeadLists
    with TableInfo<$LeadListsTable, LeadList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorHex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lead_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeadList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeadList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeadList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LeadListsTable createAlias(String alias) {
    return $LeadListsTable(attachedDatabase, alias);
  }
}

class LeadList extends DataClass implements Insertable<LeadList> {
  final String id;
  final String name;
  final String? colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LeadList({
    required this.id,
    required this.name,
    this.colorHex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LeadListsCompanion toCompanion(bool nullToAbsent) {
    return LeadListsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LeadList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeadList(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String?>(colorHex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LeadList copyWith({
    String? id,
    String? name,
    Value<String?> colorHex = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LeadList(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LeadList copyWithCompanion(LeadListsCompanion data) {
    return LeadList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeadList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeadList &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LeadListsCompanion extends UpdateCompanion<LeadList> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> colorHex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LeadListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeadListsCompanion.insert({
    required String id,
    required String name,
    this.colorHex = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LeadList> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeadListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? colorHex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LeadListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('LeadListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeadsTable extends Leads with TableInfo<$LeadsTable, Lead> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lead_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedPhoneNumberMeta =
      const VerificationMeta('normalizedPhoneNumber');
  @override
  late final GeneratedColumn<String> normalizedPhoneNumber =
      GeneratedColumn<String>(
        'normalized_phone_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastContactedAtMeta = const VerificationMeta(
    'lastContactedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastContactedAt =
      GeneratedColumn<DateTime>(
        'last_contacted_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextFollowUpAtMeta = const VerificationMeta(
    'nextFollowUpAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextFollowUpAt =
      GeneratedColumn<DateTime>(
        'next_follow_up_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    name,
    phoneNumber,
    normalizedPhoneNumber,
    company,
    email,
    notes,
    status,
    createdAt,
    updatedAt,
    lastContactedAt,
    nextFollowUpAt,
    notificationId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lead> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('normalized_phone_number')) {
      context.handle(
        _normalizedPhoneNumberMeta,
        normalizedPhoneNumber.isAcceptableOrUnknown(
          data['normalized_phone_number']!,
          _normalizedPhoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedPhoneNumberMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_contacted_at')) {
      context.handle(
        _lastContactedAtMeta,
        lastContactedAt.isAcceptableOrUnknown(
          data['last_contacted_at']!,
          _lastContactedAtMeta,
        ),
      );
    }
    if (data.containsKey('next_follow_up_at')) {
      context.handle(
        _nextFollowUpAtMeta,
        nextFollowUpAt.isAcceptableOrUnknown(
          data['next_follow_up_at']!,
          _nextFollowUpAtMeta,
        ),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lead map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lead(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      normalizedPhoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_phone_number'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastContactedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_contacted_at'],
      ),
      nextFollowUpAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_follow_up_at'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      ),
    );
  }

  @override
  $LeadsTable createAlias(String alias) {
    return $LeadsTable(attachedDatabase, alias);
  }
}

class Lead extends DataClass implements Insertable<Lead> {
  final String id;
  final String listId;
  final String? name;
  final String phoneNumber;
  final String normalizedPhoneNumber;
  final String? company;
  final String? email;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastContactedAt;
  final DateTime? nextFollowUpAt;
  final int? notificationId;
  const Lead({
    required this.id,
    required this.listId,
    this.name,
    required this.phoneNumber,
    required this.normalizedPhoneNumber,
    this.company,
    this.email,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.lastContactedAt,
    this.nextFollowUpAt,
    this.notificationId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['phone_number'] = Variable<String>(phoneNumber);
    map['normalized_phone_number'] = Variable<String>(normalizedPhoneNumber);
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastContactedAt != null) {
      map['last_contacted_at'] = Variable<DateTime>(lastContactedAt);
    }
    if (!nullToAbsent || nextFollowUpAt != null) {
      map['next_follow_up_at'] = Variable<DateTime>(nextFollowUpAt);
    }
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    return map;
  }

  LeadsCompanion toCompanion(bool nullToAbsent) {
    return LeadsCompanion(
      id: Value(id),
      listId: Value(listId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      phoneNumber: Value(phoneNumber),
      normalizedPhoneNumber: Value(normalizedPhoneNumber),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastContactedAt: lastContactedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContactedAt),
      nextFollowUpAt: nextFollowUpAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextFollowUpAt),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
    );
  }

  factory Lead.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lead(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      name: serializer.fromJson<String?>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      normalizedPhoneNumber: serializer.fromJson<String>(
        json['normalizedPhoneNumber'],
      ),
      company: serializer.fromJson<String?>(json['company']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastContactedAt: serializer.fromJson<DateTime?>(json['lastContactedAt']),
      nextFollowUpAt: serializer.fromJson<DateTime?>(json['nextFollowUpAt']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'name': serializer.toJson<String?>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'normalizedPhoneNumber': serializer.toJson<String>(normalizedPhoneNumber),
      'company': serializer.toJson<String?>(company),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastContactedAt': serializer.toJson<DateTime?>(lastContactedAt),
      'nextFollowUpAt': serializer.toJson<DateTime?>(nextFollowUpAt),
      'notificationId': serializer.toJson<int?>(notificationId),
    };
  }

  Lead copyWith({
    String? id,
    String? listId,
    Value<String?> name = const Value.absent(),
    String? phoneNumber,
    String? normalizedPhoneNumber,
    Value<String?> company = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastContactedAt = const Value.absent(),
    Value<DateTime?> nextFollowUpAt = const Value.absent(),
    Value<int?> notificationId = const Value.absent(),
  }) => Lead(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    name: name.present ? name.value : this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    normalizedPhoneNumber: normalizedPhoneNumber ?? this.normalizedPhoneNumber,
    company: company.present ? company.value : this.company,
    email: email.present ? email.value : this.email,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastContactedAt: lastContactedAt.present
        ? lastContactedAt.value
        : this.lastContactedAt,
    nextFollowUpAt: nextFollowUpAt.present
        ? nextFollowUpAt.value
        : this.nextFollowUpAt,
    notificationId: notificationId.present
        ? notificationId.value
        : this.notificationId,
  );
  Lead copyWithCompanion(LeadsCompanion data) {
    return Lead(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      normalizedPhoneNumber: data.normalizedPhoneNumber.present
          ? data.normalizedPhoneNumber.value
          : this.normalizedPhoneNumber,
      company: data.company.present ? data.company.value : this.company,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastContactedAt: data.lastContactedAt.present
          ? data.lastContactedAt.value
          : this.lastContactedAt,
      nextFollowUpAt: data.nextFollowUpAt.present
          ? data.nextFollowUpAt.value
          : this.nextFollowUpAt,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lead(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('normalizedPhoneNumber: $normalizedPhoneNumber, ')
          ..write('company: $company, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastContactedAt: $lastContactedAt, ')
          ..write('nextFollowUpAt: $nextFollowUpAt, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    name,
    phoneNumber,
    normalizedPhoneNumber,
    company,
    email,
    notes,
    status,
    createdAt,
    updatedAt,
    lastContactedAt,
    nextFollowUpAt,
    notificationId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lead &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.normalizedPhoneNumber == this.normalizedPhoneNumber &&
          other.company == this.company &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastContactedAt == this.lastContactedAt &&
          other.nextFollowUpAt == this.nextFollowUpAt &&
          other.notificationId == this.notificationId);
}

class LeadsCompanion extends UpdateCompanion<Lead> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String?> name;
  final Value<String> phoneNumber;
  final Value<String> normalizedPhoneNumber;
  final Value<String?> company;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastContactedAt;
  final Value<DateTime?> nextFollowUpAt;
  final Value<int?> notificationId;
  final Value<int> rowid;
  const LeadsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.normalizedPhoneNumber = const Value.absent(),
    this.company = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastContactedAt = const Value.absent(),
    this.nextFollowUpAt = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeadsCompanion.insert({
    required String id,
    required String listId,
    this.name = const Value.absent(),
    required String phoneNumber,
    required String normalizedPhoneNumber,
    this.company = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastContactedAt = const Value.absent(),
    this.nextFollowUpAt = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       phoneNumber = Value(phoneNumber),
       normalizedPhoneNumber = Value(normalizedPhoneNumber),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Lead> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? normalizedPhoneNumber,
    Expression<String>? company,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastContactedAt,
    Expression<DateTime>? nextFollowUpAt,
    Expression<int>? notificationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (normalizedPhoneNumber != null)
        'normalized_phone_number': normalizedPhoneNumber,
      if (company != null) 'company': company,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastContactedAt != null) 'last_contacted_at': lastContactedAt,
      if (nextFollowUpAt != null) 'next_follow_up_at': nextFollowUpAt,
      if (notificationId != null) 'notification_id': notificationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeadsCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String?>? name,
    Value<String>? phoneNumber,
    Value<String>? normalizedPhoneNumber,
    Value<String?>? company,
    Value<String?>? email,
    Value<String?>? notes,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastContactedAt,
    Value<DateTime?>? nextFollowUpAt,
    Value<int?>? notificationId,
    Value<int>? rowid,
  }) {
    return LeadsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      normalizedPhoneNumber:
          normalizedPhoneNumber ?? this.normalizedPhoneNumber,
      company: company ?? this.company,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      nextFollowUpAt: nextFollowUpAt ?? this.nextFollowUpAt,
      notificationId: notificationId ?? this.notificationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (normalizedPhoneNumber.present) {
      map['normalized_phone_number'] = Variable<String>(
        normalizedPhoneNumber.value,
      );
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastContactedAt.present) {
      map['last_contacted_at'] = Variable<DateTime>(lastContactedAt.value);
    }
    if (nextFollowUpAt.present) {
      map['next_follow_up_at'] = Variable<DateTime>(nextFollowUpAt.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('normalizedPhoneNumber: $normalizedPhoneNumber, ')
          ..write('company: $company, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastContactedAt: $lastContactedAt, ')
          ..write('nextFollowUpAt: $nextFollowUpAt, ')
          ..write('notificationId: $notificationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LeadListsTable leadLists = $LeadListsTable(this);
  late final $LeadsTable leads = $LeadsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [leadLists, leads];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lead_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('leads', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LeadListsTableCreateCompanionBuilder = LeadListsCompanion Function({
  required String id,
  required String name,
  Value<String?> colorHex,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LeadListsTableUpdateCompanionBuilder = LeadListsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> colorHex,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$LeadListsTableReferences
    extends BaseReferences<_$AppDatabase, $LeadListsTable, LeadList> {
  $$LeadListsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LeadsTable, List<Lead>> _leadsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.leads,
    aliasName: 'lead_lists__id__leads__list_id',
  );

  $$LeadsTableProcessedTableManager get leadsRefs {
    final manager = $$LeadsTableTableManager(
      $_db,
      $_db.leads,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_leadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeadListsTableFilterComposer
    extends Composer<_$AppDatabase, $LeadListsTable> {
  $$LeadListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> leadsRefs(
    Expression<bool> Function($$LeadsTableFilterComposer f) f,
  ) {
    final $$LeadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leads,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeadsTableFilterComposer(
            $db: $db,
            $table: $db.leads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeadListsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadListsTable> {
  $$LeadListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadListsTable> {
  $$LeadListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> leadsRefs<T extends Object>(
    Expression<T> Function($$LeadsTableAnnotationComposer a) f,
  ) {
    final $$LeadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leads,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeadsTableAnnotationComposer(
            $db: $db,
            $table: $db.leads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeadListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadListsTable,
          LeadList,
          $$LeadListsTableFilterComposer,
          $$LeadListsTableOrderingComposer,
          $$LeadListsTableAnnotationComposer,
          $$LeadListsTableCreateCompanionBuilder,
          $$LeadListsTableUpdateCompanionBuilder,
          (LeadList, $$LeadListsTableReferences),
          LeadList,
          PrefetchHooks Function({bool leadsRefs})
        > {
  $$LeadListsTableTableManager(_$AppDatabase db, $LeadListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadListsCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> colorHex = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LeadListsCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeadListsTable, LeadList>(table),
                  $$LeadListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leadsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (leadsRefs) db.leads],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (leadsRefs)
                    await $_getPrefetchedDataByColumns<
                      LeadList,
                      $LeadListsTable,
                      Lead,
                      $LeadsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LeadListsTableReferences
                          ._leadsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LeadListsTableReferences(db, table, p0).leadsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'list_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LeadListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadListsTable,
      LeadList,
      $$LeadListsTableFilterComposer,
      $$LeadListsTableOrderingComposer,
      $$LeadListsTableAnnotationComposer,
      $$LeadListsTableCreateCompanionBuilder,
      $$LeadListsTableUpdateCompanionBuilder,
      (LeadList, $$LeadListsTableReferences),
      LeadList,
      PrefetchHooks Function({bool leadsRefs})
    >;
typedef $$LeadsTableCreateCompanionBuilder = LeadsCompanion Function({
  required String id,
  required String listId,
  Value<String?> name,
  required String phoneNumber,
  required String normalizedPhoneNumber,
  Value<String?> company,
  Value<String?> email,
  Value<String?> notes,
  Value<String> status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastContactedAt,
  Value<DateTime?> nextFollowUpAt,
  Value<int?> notificationId,
  Value<int> rowid,
});
typedef $$LeadsTableUpdateCompanionBuilder = LeadsCompanion Function({
  Value<String> id,
  Value<String> listId,
  Value<String?> name,
  Value<String> phoneNumber,
  Value<String> normalizedPhoneNumber,
  Value<String?> company,
  Value<String?> email,
  Value<String?> notes,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastContactedAt,
  Value<DateTime?> nextFollowUpAt,
  Value<int?> notificationId,
  Value<int> rowid,
});

final class $$LeadsTableReferences
    extends BaseReferences<_$AppDatabase, $LeadsTable, Lead> {
  $$LeadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LeadListsTable _listIdTable(_$AppDatabase db) =>
      db.leadLists.createAlias('leads__list_id__lead_lists__id');

  $$LeadListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<String>('list_id')!;

    final manager = $$LeadListsTableTableManager(
      $_db,
      $_db.leadLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeadsTableFilterComposer extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedPhoneNumber => $composableBuilder(
    column: $table.normalizedPhoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastContactedAt => $composableBuilder(
    column: $table.lastContactedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextFollowUpAt => $composableBuilder(
    column: $table.nextFollowUpAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  $$LeadListsTableFilterComposer get listId {
    final $$LeadListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.leadLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeadListsTableFilterComposer(
            $db: $db,
            $table: $db.leadLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeadsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedPhoneNumber => $composableBuilder(
    column: $table.normalizedPhoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastContactedAt => $composableBuilder(
    column: $table.lastContactedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextFollowUpAt => $composableBuilder(
    column: $table.nextFollowUpAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeadListsTableOrderingComposer get listId {
    final $$LeadListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.leadLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeadListsTableOrderingComposer(
            $db: $db,
            $table: $db.leadLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedPhoneNumber => $composableBuilder(
    column: $table.normalizedPhoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastContactedAt => $composableBuilder(
    column: $table.lastContactedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextFollowUpAt => $composableBuilder(
    column: $table.nextFollowUpAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  $$LeadListsTableAnnotationComposer get listId {
    final $$LeadListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.leadLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeadListsTableAnnotationComposer(
            $db: $db,
            $table: $db.leadLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadsTable,
          Lead,
          $$LeadsTableFilterComposer,
          $$LeadsTableOrderingComposer,
          $$LeadsTableAnnotationComposer,
          $$LeadsTableCreateCompanionBuilder,
          $$LeadsTableUpdateCompanionBuilder,
          (Lead, $$LeadsTableReferences),
          Lead,
          PrefetchHooks Function({bool listId})
        > {
  $$LeadsTableTableManager(_$AppDatabase db, $LeadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> normalizedPhoneNumber = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastContactedAt = const Value.absent(),
                Value<DateTime?> nextFollowUpAt = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion(
                id: id,
                listId: listId,
                name: name,
                phoneNumber: phoneNumber,
                normalizedPhoneNumber: normalizedPhoneNumber,
                company: company,
                email: email,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastContactedAt: lastContactedAt,
                nextFollowUpAt: nextFollowUpAt,
                notificationId: notificationId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                Value<String?> name = const Value.absent(),
                required String phoneNumber,
                required String normalizedPhoneNumber,
                Value<String?> company = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastContactedAt = const Value.absent(),
                Value<DateTime?> nextFollowUpAt = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion.insert(
                id: id,
                listId: listId,
                name: name,
                phoneNumber: phoneNumber,
                normalizedPhoneNumber: normalizedPhoneNumber,
                company: company,
                email: email,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastContactedAt: lastContactedAt,
                nextFollowUpAt: nextFollowUpAt,
                notificationId: notificationId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeadsTable, Lead>(table),
                  $$LeadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.listId,
                        referencedTable: $$LeadsTableReferences._listIdTable(
                          db,
                        ),
                        referencedColumn: $$LeadsTableReferences
                            ._listIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadsTable,
      Lead,
      $$LeadsTableFilterComposer,
      $$LeadsTableOrderingComposer,
      $$LeadsTableAnnotationComposer,
      $$LeadsTableCreateCompanionBuilder,
      $$LeadsTableUpdateCompanionBuilder,
      (Lead, $$LeadsTableReferences),
      Lead,
      PrefetchHooks Function({bool listId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LeadListsTableTableManager get leadLists =>
      $$LeadListsTableTableManager(_db, _db.leadLists);
  $$LeadsTableTableManager get leads =>
      $$LeadsTableTableManager(_db, _db.leads);
}
