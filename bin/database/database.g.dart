// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Role extends DataClass implements Insertable<Role> {
  final int id;
  final String name;
  Role({required this.id, required this.name});
  factory Role.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Role(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Role.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Role copyWith({int? id, String? name}) => Role(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Role(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Role && other.id == this.id && other.name == this.name);
}

class RolesCompanion extends UpdateCompanion<Role> {
  final Value<int> id;
  final Value<String> name;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RolesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Role> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RolesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class Roles extends Table with TableInfo<Roles, Role> {
  final GeneratedDatabase _db;
  final String? _alias;
  Roles(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'roles';
  @override
  String get actualTableName => 'roles';
  @override
  VerificationContext validateIntegrity(Insertable<Role> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Role.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Roles createAlias(String alias) {
    return Roles(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Language extends DataClass implements Insertable<Language> {
  final int id;
  final String short;
  final String long;
  final String native;
  Language(
      {required this.id,
      required this.short,
      required this.long,
      required this.native});
  factory Language.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Language(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      short: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}short'])!,
      long: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}long'])!,
      native: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}native'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['short'] = Variable<String>(short);
    map['long'] = Variable<String>(long);
    map['native'] = Variable<String>(native);
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      id: Value(id),
      short: Value(short),
      long: Value(long),
      native: Value(native),
    );
  }

  factory Language.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      id: serializer.fromJson<int>(json['id']),
      short: serializer.fromJson<String>(json['short']),
      long: serializer.fromJson<String>(json['long']),
      native: serializer.fromJson<String>(json['native']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'short': serializer.toJson<String>(short),
      'long': serializer.toJson<String>(long),
      'native': serializer.toJson<String>(native),
    };
  }

  Language copyWith({int? id, String? short, String? long, String? native}) =>
      Language(
        id: id ?? this.id,
        short: short ?? this.short,
        long: long ?? this.long,
        native: native ?? this.native,
      );
  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('id: $id, ')
          ..write('short: $short, ')
          ..write('long: $long, ')
          ..write('native: $native')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, short, long, native);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.id == this.id &&
          other.short == this.short &&
          other.long == this.long &&
          other.native == this.native);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<int> id;
  final Value<String> short;
  final Value<String> long;
  final Value<String> native;
  const LanguagesCompanion({
    this.id = const Value.absent(),
    this.short = const Value.absent(),
    this.long = const Value.absent(),
    this.native = const Value.absent(),
  });
  LanguagesCompanion.insert({
    this.id = const Value.absent(),
    required String short,
    required String long,
    required String native,
  })  : short = Value(short),
        long = Value(long),
        native = Value(native);
  static Insertable<Language> custom({
    Expression<int>? id,
    Expression<String>? short,
    Expression<String>? long,
    Expression<String>? native,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (short != null) 'short': short,
      if (long != null) 'long': long,
      if (native != null) 'native': native,
    });
  }

  LanguagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? short,
      Value<String>? long,
      Value<String>? native}) {
    return LanguagesCompanion(
      id: id ?? this.id,
      short: short ?? this.short,
      long: long ?? this.long,
      native: native ?? this.native,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (short.present) {
      map['short'] = Variable<String>(short.value);
    }
    if (long.present) {
      map['long'] = Variable<String>(long.value);
    }
    if (native.present) {
      map['native'] = Variable<String>(native.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('id: $id, ')
          ..write('short: $short, ')
          ..write('long: $long, ')
          ..write('native: $native')
          ..write(')'))
        .toString();
  }
}

class Languages extends Table with TableInfo<Languages, Language> {
  final GeneratedDatabase _db;
  final String? _alias;
  Languages(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _shortMeta = const VerificationMeta('short');
  late final GeneratedColumn<String?> short = GeneratedColumn<String?>(
      'short', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _longMeta = const VerificationMeta('long');
  late final GeneratedColumn<String?> long = GeneratedColumn<String?>(
      'long', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _nativeMeta = const VerificationMeta('native');
  late final GeneratedColumn<String?> native = GeneratedColumn<String?>(
      'native', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, short, long, native];
  @override
  String get aliasedName => _alias ?? 'languages';
  @override
  String get actualTableName => 'languages';
  @override
  VerificationContext validateIntegrity(Insertable<Language> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('short')) {
      context.handle(
          _shortMeta, short.isAcceptableOrUnknown(data['short']!, _shortMeta));
    } else if (isInserting) {
      context.missing(_shortMeta);
    }
    if (data.containsKey('long')) {
      context.handle(
          _longMeta, long.isAcceptableOrUnknown(data['long']!, _longMeta));
    } else if (isInserting) {
      context.missing(_longMeta);
    }
    if (data.containsKey('native')) {
      context.handle(_nativeMeta,
          native.isAcceptableOrUnknown(data['native']!, _nativeMeta));
    } else if (isInserting) {
      context.missing(_nativeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Language map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Language.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Languages createAlias(String alias) {
    return Languages(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final int date;
  final String name;
  final String? password;
  final int role;
  final int status;
  final int language;
  User(
      {required this.id,
      required this.date,
      required this.name,
      this.password,
      required this.role,
      required this.status,
      required this.language});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      role: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      language: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}language'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    map['role'] = Variable<int>(role);
    map['status'] = Variable<int>(status);
    map['language'] = Variable<int>(language);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      date: Value(date),
      name: Value(name),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      role: Value(role),
      status: Value(status),
      language: Value(language),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String?>(json['password']),
      role: serializer.fromJson<int>(json['role']),
      status: serializer.fromJson<int>(json['status']),
      language: serializer.fromJson<int>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String?>(password),
      'role': serializer.toJson<int>(role),
      'status': serializer.toJson<int>(status),
      'language': serializer.toJson<int>(language),
    };
  }

  User copyWith(
          {int? id,
          int? date,
          String? name,
          String? password,
          int? role,
          int? status,
          int? language}) =>
      User(
        id: id ?? this.id,
        date: date ?? this.date,
        name: name ?? this.name,
        password: password ?? this.password,
        role: role ?? this.role,
        status: status ?? this.status,
        language: language ?? this.language,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, name, password, role, status, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.date == this.date &&
          other.name == this.name &&
          other.password == this.password &&
          other.role == this.role &&
          other.status == this.status &&
          other.language == this.language);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<int> date;
  final Value<String> name;
  final Value<String?> password;
  final Value<int> role;
  final Value<int> status;
  final Value<int> language;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.language = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required String name,
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.language = const Value.absent(),
  })  : date = Value(date),
        name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<String>? name,
    Expression<String?>? password,
    Expression<int>? role,
    Expression<int>? status,
    Expression<int>? language,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (language != null) 'language': language,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<int>? date,
      Value<String>? name,
      Value<String?>? password,
      Value<int>? role,
      Value<int>? status,
      Value<int>? language}) {
    return UsersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      language: language ?? this.language,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<int>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (language.present) {
      map['language'] = Variable<int>(language.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }
}

class Users extends Table with TableInfo<Users, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  Users(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  late final GeneratedColumn<int?> role = GeneratedColumn<int?>(
      'role', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression<int>('0'));
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression<int>('0'));
  final VerificationMeta _languageMeta = const VerificationMeta('language');
  late final GeneratedColumn<int?> language = GeneratedColumn<int?>(
      'language', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression<int>('0'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, name, password, role, status, language];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Users createAlias(String alias) {
    return Users(_db, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY (role) REFERENCES roles (id)',
        'FOREIGN KEY (status) REFERENCES roles (id)',
        'FOREIGN KEY (language) REFERENCES languages (id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class status extends DataClass implements Insertable<status> {
  final int id;
  final String name;
  status({required this.id, required this.name});
  factory status.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return status(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  StatusesCompanion toCompanion(bool nullToAbsent) {
    return StatusesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory status.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return status(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  status copyWith({int? id, String? name}) => status(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('status(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is status && other.id == this.id && other.name == this.name);
}

class StatusesCompanion extends UpdateCompanion<status> {
  final Value<int> id;
  final Value<String> name;
  const StatusesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  StatusesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<status> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  StatusesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return StatusesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatusesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class Statuses extends Table with TableInfo<Statuses, status> {
  final GeneratedDatabase _db;
  final String? _alias;
  Statuses(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'statuses';
  @override
  String get actualTableName => 'statuses';
  @override
  VerificationContext validateIntegrity(Insertable<status> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  status map(Map<String, dynamic> data, {String? tablePrefix}) {
    return status.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Statuses createAlias(String alias) {
    return Statuses(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class userinput extends DataClass implements Insertable<userinput> {
  final int id;
  final int date;
  final int user;
  final String input;
  userinput(
      {required this.id,
      required this.date,
      required this.user,
      required this.input});
  factory userinput.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return userinput(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      user: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user'])!,
      input: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}input'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['user'] = Variable<int>(user);
    map['input'] = Variable<String>(input);
    return map;
  }

  UsersinputCompanion toCompanion(bool nullToAbsent) {
    return UsersinputCompanion(
      id: Value(id),
      date: Value(date),
      user: Value(user),
      input: Value(input),
    );
  }

  factory userinput.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return userinput(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      user: serializer.fromJson<int>(json['user']),
      input: serializer.fromJson<String>(json['input']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'user': serializer.toJson<int>(user),
      'input': serializer.toJson<String>(input),
    };
  }

  userinput copyWith({int? id, int? date, int? user, String? input}) =>
      userinput(
        id: id ?? this.id,
        date: date ?? this.date,
        user: user ?? this.user,
        input: input ?? this.input,
      );
  @override
  String toString() {
    return (StringBuffer('userinput(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('user: $user, ')
          ..write('input: $input')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, user, input);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is userinput &&
          other.id == this.id &&
          other.date == this.date &&
          other.user == this.user &&
          other.input == this.input);
}

class UsersinputCompanion extends UpdateCompanion<userinput> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> user;
  final Value<String> input;
  const UsersinputCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.user = const Value.absent(),
    this.input = const Value.absent(),
  });
  UsersinputCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int user,
    required String input,
  })  : date = Value(date),
        user = Value(user),
        input = Value(input);
  static Insertable<userinput> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? user,
    Expression<String>? input,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (user != null) 'user': user,
      if (input != null) 'input': input,
    });
  }

  UsersinputCompanion copyWith(
      {Value<int>? id,
      Value<int>? date,
      Value<int>? user,
      Value<String>? input}) {
    return UsersinputCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      user: user ?? this.user,
      input: input ?? this.input,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (input.present) {
      map['input'] = Variable<String>(input.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersinputCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('user: $user, ')
          ..write('input: $input')
          ..write(')'))
        .toString();
  }
}

class Usersinput extends Table with TableInfo<Usersinput, userinput> {
  final GeneratedDatabase _db;
  final String? _alias;
  Usersinput(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<int?> user = GeneratedColumn<int?>(
      'user', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _inputMeta = const VerificationMeta('input');
  late final GeneratedColumn<String?> input = GeneratedColumn<String?>(
      'input', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, date, user, input];
  @override
  String get aliasedName => _alias ?? 'usersinput';
  @override
  String get actualTableName => 'usersinput';
  @override
  VerificationContext validateIntegrity(Insertable<userinput> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('user')) {
      context.handle(
          _userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('input')) {
      context.handle(
          _inputMeta, input.isAcceptableOrUnknown(data['input']!, _inputMeta));
    } else if (isInserting) {
      context.missing(_inputMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  userinput map(Map<String, dynamic> data, {String? tablePrefix}) {
    return userinput.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Usersinput createAlias(String alias) {
    return Usersinput(_db, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['FOREIGN KEY (user) REFERENCES users (id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Login extends DataClass implements Insertable<Login> {
  final int id;
  final int date;
  final int user;
  final int connection;
  Login(
      {required this.id,
      required this.date,
      required this.user,
      required this.connection});
  factory Login.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Login(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      user: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user'])!,
      connection: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}connection'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['user'] = Variable<int>(user);
    map['connection'] = Variable<int>(connection);
    return map;
  }

  LoginsCompanion toCompanion(bool nullToAbsent) {
    return LoginsCompanion(
      id: Value(id),
      date: Value(date),
      user: Value(user),
      connection: Value(connection),
    );
  }

  factory Login.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Login(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      user: serializer.fromJson<int>(json['user']),
      connection: serializer.fromJson<int>(json['connection']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'user': serializer.toJson<int>(user),
      'connection': serializer.toJson<int>(connection),
    };
  }

  Login copyWith({int? id, int? date, int? user, int? connection}) => Login(
        id: id ?? this.id,
        date: date ?? this.date,
        user: user ?? this.user,
        connection: connection ?? this.connection,
      );
  @override
  String toString() {
    return (StringBuffer('Login(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('user: $user, ')
          ..write('connection: $connection')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, user, connection);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Login &&
          other.id == this.id &&
          other.date == this.date &&
          other.user == this.user &&
          other.connection == this.connection);
}

class LoginsCompanion extends UpdateCompanion<Login> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> user;
  final Value<int> connection;
  const LoginsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.user = const Value.absent(),
    this.connection = const Value.absent(),
  });
  LoginsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int user,
    required int connection,
  })  : date = Value(date),
        user = Value(user),
        connection = Value(connection);
  static Insertable<Login> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? user,
    Expression<int>? connection,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (user != null) 'user': user,
      if (connection != null) 'connection': connection,
    });
  }

  LoginsCompanion copyWith(
      {Value<int>? id,
      Value<int>? date,
      Value<int>? user,
      Value<int>? connection}) {
    return LoginsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      user: user ?? this.user,
      connection: connection ?? this.connection,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (connection.present) {
      map['connection'] = Variable<int>(connection.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoginsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('user: $user, ')
          ..write('connection: $connection')
          ..write(')'))
        .toString();
  }
}

class Logins extends Table with TableInfo<Logins, Login> {
  final GeneratedDatabase _db;
  final String? _alias;
  Logins(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<int?> user = GeneratedColumn<int?>(
      'user', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _connectionMeta = const VerificationMeta('connection');
  late final GeneratedColumn<int?> connection = GeneratedColumn<int?>(
      'connection', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, date, user, connection];
  @override
  String get aliasedName => _alias ?? 'logins';
  @override
  String get actualTableName => 'logins';
  @override
  VerificationContext validateIntegrity(Insertable<Login> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('user')) {
      context.handle(
          _userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('connection')) {
      context.handle(
          _connectionMeta,
          connection.isAcceptableOrUnknown(
              data['connection']!, _connectionMeta));
    } else if (isInserting) {
      context.missing(_connectionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Login map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Login.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Logins createAlias(String alias) {
    return Logins(_db, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['FOREIGN KEY (user) REFERENCES users (id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final int datestarted;
  final int player1;
  final int player2;
  final int? datefinished;
  final int result;
  final int? winner;
  final int? looser;
  Game(
      {required this.id,
      required this.datestarted,
      required this.player1,
      required this.player2,
      this.datefinished,
      required this.result,
      this.winner,
      this.looser});
  factory Game.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Game(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      datestarted: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}datestarted'])!,
      player1: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}player1'])!,
      player2: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}player2'])!,
      datefinished: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}datefinished']),
      result: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}result'])!,
      winner: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}winner']),
      looser: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}looser']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['datestarted'] = Variable<int>(datestarted);
    map['player1'] = Variable<int>(player1);
    map['player2'] = Variable<int>(player2);
    if (!nullToAbsent || datefinished != null) {
      map['datefinished'] = Variable<int?>(datefinished);
    }
    map['result'] = Variable<int>(result);
    if (!nullToAbsent || winner != null) {
      map['winner'] = Variable<int?>(winner);
    }
    if (!nullToAbsent || looser != null) {
      map['looser'] = Variable<int?>(looser);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      datestarted: Value(datestarted),
      player1: Value(player1),
      player2: Value(player2),
      datefinished: datefinished == null && nullToAbsent
          ? const Value.absent()
          : Value(datefinished),
      result: Value(result),
      winner:
          winner == null && nullToAbsent ? const Value.absent() : Value(winner),
      looser:
          looser == null && nullToAbsent ? const Value.absent() : Value(looser),
    );
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      datestarted: serializer.fromJson<int>(json['datestarted']),
      player1: serializer.fromJson<int>(json['player1']),
      player2: serializer.fromJson<int>(json['player2']),
      datefinished: serializer.fromJson<int?>(json['datefinished']),
      result: serializer.fromJson<int>(json['result']),
      winner: serializer.fromJson<int?>(json['winner']),
      looser: serializer.fromJson<int?>(json['looser']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'datestarted': serializer.toJson<int>(datestarted),
      'player1': serializer.toJson<int>(player1),
      'player2': serializer.toJson<int>(player2),
      'datefinished': serializer.toJson<int?>(datefinished),
      'result': serializer.toJson<int>(result),
      'winner': serializer.toJson<int?>(winner),
      'looser': serializer.toJson<int?>(looser),
    };
  }

  Game copyWith(
          {int? id,
          int? datestarted,
          int? player1,
          int? player2,
          int? datefinished,
          int? result,
          int? winner,
          int? looser}) =>
      Game(
        id: id ?? this.id,
        datestarted: datestarted ?? this.datestarted,
        player1: player1 ?? this.player1,
        player2: player2 ?? this.player2,
        datefinished: datefinished ?? this.datefinished,
        result: result ?? this.result,
        winner: winner ?? this.winner,
        looser: looser ?? this.looser,
      );
  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('datestarted: $datestarted, ')
          ..write('player1: $player1, ')
          ..write('player2: $player2, ')
          ..write('datefinished: $datefinished, ')
          ..write('result: $result, ')
          ..write('winner: $winner, ')
          ..write('looser: $looser')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, datestarted, player1, player2, datefinished, result, winner, looser);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.datestarted == this.datestarted &&
          other.player1 == this.player1 &&
          other.player2 == this.player2 &&
          other.datefinished == this.datefinished &&
          other.result == this.result &&
          other.winner == this.winner &&
          other.looser == this.looser);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<int> datestarted;
  final Value<int> player1;
  final Value<int> player2;
  final Value<int?> datefinished;
  final Value<int> result;
  final Value<int?> winner;
  final Value<int?> looser;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.datestarted = const Value.absent(),
    this.player1 = const Value.absent(),
    this.player2 = const Value.absent(),
    this.datefinished = const Value.absent(),
    this.result = const Value.absent(),
    this.winner = const Value.absent(),
    this.looser = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required int datestarted,
    required int player1,
    required int player2,
    this.datefinished = const Value.absent(),
    this.result = const Value.absent(),
    this.winner = const Value.absent(),
    this.looser = const Value.absent(),
  })  : datestarted = Value(datestarted),
        player1 = Value(player1),
        player2 = Value(player2);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<int>? datestarted,
    Expression<int>? player1,
    Expression<int>? player2,
    Expression<int?>? datefinished,
    Expression<int>? result,
    Expression<int?>? winner,
    Expression<int?>? looser,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datestarted != null) 'datestarted': datestarted,
      if (player1 != null) 'player1': player1,
      if (player2 != null) 'player2': player2,
      if (datefinished != null) 'datefinished': datefinished,
      if (result != null) 'result': result,
      if (winner != null) 'winner': winner,
      if (looser != null) 'looser': looser,
    });
  }

  GamesCompanion copyWith(
      {Value<int>? id,
      Value<int>? datestarted,
      Value<int>? player1,
      Value<int>? player2,
      Value<int?>? datefinished,
      Value<int>? result,
      Value<int?>? winner,
      Value<int?>? looser}) {
    return GamesCompanion(
      id: id ?? this.id,
      datestarted: datestarted ?? this.datestarted,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      datefinished: datefinished ?? this.datefinished,
      result: result ?? this.result,
      winner: winner ?? this.winner,
      looser: looser ?? this.looser,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (datestarted.present) {
      map['datestarted'] = Variable<int>(datestarted.value);
    }
    if (player1.present) {
      map['player1'] = Variable<int>(player1.value);
    }
    if (player2.present) {
      map['player2'] = Variable<int>(player2.value);
    }
    if (datefinished.present) {
      map['datefinished'] = Variable<int?>(datefinished.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(result.value);
    }
    if (winner.present) {
      map['winner'] = Variable<int?>(winner.value);
    }
    if (looser.present) {
      map['looser'] = Variable<int?>(looser.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('datestarted: $datestarted, ')
          ..write('player1: $player1, ')
          ..write('player2: $player2, ')
          ..write('datefinished: $datefinished, ')
          ..write('result: $result, ')
          ..write('winner: $winner, ')
          ..write('looser: $looser')
          ..write(')'))
        .toString();
  }
}

class Games extends Table with TableInfo<Games, Game> {
  final GeneratedDatabase _db;
  final String? _alias;
  Games(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _datestartedMeta =
      const VerificationMeta('datestarted');
  late final GeneratedColumn<int?> datestarted = GeneratedColumn<int?>(
      'datestarted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _player1Meta = const VerificationMeta('player1');
  late final GeneratedColumn<int?> player1 = GeneratedColumn<int?>(
      'player1', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _player2Meta = const VerificationMeta('player2');
  late final GeneratedColumn<int?> player2 = GeneratedColumn<int?>(
      'player2', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _datefinishedMeta =
      const VerificationMeta('datefinished');
  late final GeneratedColumn<int?> datefinished = GeneratedColumn<int?>(
      'datefinished', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _resultMeta = const VerificationMeta('result');
  late final GeneratedColumn<int?> result = GeneratedColumn<int?>(
      'result', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression<int>('0'));
  final VerificationMeta _winnerMeta = const VerificationMeta('winner');
  late final GeneratedColumn<int?> winner = GeneratedColumn<int?>(
      'winner', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _looserMeta = const VerificationMeta('looser');
  late final GeneratedColumn<int?> looser = GeneratedColumn<int?>(
      'looser', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false, $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, datestarted, player1, player2, datefinished, result, winner, looser];
  @override
  String get aliasedName => _alias ?? 'games';
  @override
  String get actualTableName => 'games';
  @override
  VerificationContext validateIntegrity(Insertable<Game> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('datestarted')) {
      context.handle(
          _datestartedMeta,
          datestarted.isAcceptableOrUnknown(
              data['datestarted']!, _datestartedMeta));
    } else if (isInserting) {
      context.missing(_datestartedMeta);
    }
    if (data.containsKey('player1')) {
      context.handle(_player1Meta,
          player1.isAcceptableOrUnknown(data['player1']!, _player1Meta));
    } else if (isInserting) {
      context.missing(_player1Meta);
    }
    if (data.containsKey('player2')) {
      context.handle(_player2Meta,
          player2.isAcceptableOrUnknown(data['player2']!, _player2Meta));
    } else if (isInserting) {
      context.missing(_player2Meta);
    }
    if (data.containsKey('datefinished')) {
      context.handle(
          _datefinishedMeta,
          datefinished.isAcceptableOrUnknown(
              data['datefinished']!, _datefinishedMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    }
    if (data.containsKey('winner')) {
      context.handle(_winnerMeta,
          winner.isAcceptableOrUnknown(data['winner']!, _winnerMeta));
    }
    if (data.containsKey('looser')) {
      context.handle(_looserMeta,
          looser.isAcceptableOrUnknown(data['looser']!, _looserMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Game.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Games createAlias(String alias) {
    return Games(_db, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY (player1) REFERENCES users (id)',
        'FOREIGN KEY (player2) REFERENCES users (id)',
        'FOREIGN KEY (winner) REFERENCES users (id)',
        'FOREIGN KEY (looser) REFERENCES users (id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Gamelog extends DataClass implements Insertable<Gamelog> {
  final int id;
  final int date;
  final int game;
  final int user;
  final String input;
  final String result;
  Gamelog(
      {required this.id,
      required this.date,
      required this.game,
      required this.user,
      required this.input,
      required this.result});
  factory Gamelog.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Gamelog(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      date: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      game: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}game'])!,
      user: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user'])!,
      input: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}input'])!,
      result: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}result'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['game'] = Variable<int>(game);
    map['user'] = Variable<int>(user);
    map['input'] = Variable<String>(input);
    map['result'] = Variable<String>(result);
    return map;
  }

  GamelogsCompanion toCompanion(bool nullToAbsent) {
    return GamelogsCompanion(
      id: Value(id),
      date: Value(date),
      game: Value(game),
      user: Value(user),
      input: Value(input),
      result: Value(result),
    );
  }

  factory Gamelog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gamelog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      game: serializer.fromJson<int>(json['game']),
      user: serializer.fromJson<int>(json['user']),
      input: serializer.fromJson<String>(json['input']),
      result: serializer.fromJson<String>(json['result']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'game': serializer.toJson<int>(game),
      'user': serializer.toJson<int>(user),
      'input': serializer.toJson<String>(input),
      'result': serializer.toJson<String>(result),
    };
  }

  Gamelog copyWith(
          {int? id,
          int? date,
          int? game,
          int? user,
          String? input,
          String? result}) =>
      Gamelog(
        id: id ?? this.id,
        date: date ?? this.date,
        game: game ?? this.game,
        user: user ?? this.user,
        input: input ?? this.input,
        result: result ?? this.result,
      );
  @override
  String toString() {
    return (StringBuffer('Gamelog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('game: $game, ')
          ..write('user: $user, ')
          ..write('input: $input, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, game, user, input, result);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gamelog &&
          other.id == this.id &&
          other.date == this.date &&
          other.game == this.game &&
          other.user == this.user &&
          other.input == this.input &&
          other.result == this.result);
}

class GamelogsCompanion extends UpdateCompanion<Gamelog> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> game;
  final Value<int> user;
  final Value<String> input;
  final Value<String> result;
  const GamelogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.game = const Value.absent(),
    this.user = const Value.absent(),
    this.input = const Value.absent(),
    this.result = const Value.absent(),
  });
  GamelogsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int game,
    required int user,
    required String input,
    required String result,
  })  : date = Value(date),
        game = Value(game),
        user = Value(user),
        input = Value(input),
        result = Value(result);
  static Insertable<Gamelog> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? game,
    Expression<int>? user,
    Expression<String>? input,
    Expression<String>? result,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (game != null) 'game': game,
      if (user != null) 'user': user,
      if (input != null) 'input': input,
      if (result != null) 'result': result,
    });
  }

  GamelogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? date,
      Value<int>? game,
      Value<int>? user,
      Value<String>? input,
      Value<String>? result}) {
    return GamelogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      game: game ?? this.game,
      user: user ?? this.user,
      input: input ?? this.input,
      result: result ?? this.result,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (game.present) {
      map['game'] = Variable<int>(game.value);
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (input.present) {
      map['input'] = Variable<String>(input.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamelogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('game: $game, ')
          ..write('user: $user, ')
          ..write('input: $input, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }
}

class Gamelogs extends Table with TableInfo<Gamelogs, Gamelog> {
  final GeneratedDatabase _db;
  final String? _alias;
  Gamelogs(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<int?> date = GeneratedColumn<int?>(
      'date', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _gameMeta = const VerificationMeta('game');
  late final GeneratedColumn<int?> game = GeneratedColumn<int?>(
      'game', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<int?> user = GeneratedColumn<int?>(
      'user', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _inputMeta = const VerificationMeta('input');
  late final GeneratedColumn<String?> input = GeneratedColumn<String?>(
      'input', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _resultMeta = const VerificationMeta('result');
  late final GeneratedColumn<String?> result = GeneratedColumn<String?>(
      'result', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, date, game, user, input, result];
  @override
  String get aliasedName => _alias ?? 'gamelogs';
  @override
  String get actualTableName => 'gamelogs';
  @override
  VerificationContext validateIntegrity(Insertable<Gamelog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('game')) {
      context.handle(
          _gameMeta, game.isAcceptableOrUnknown(data['game']!, _gameMeta));
    } else if (isInserting) {
      context.missing(_gameMeta);
    }
    if (data.containsKey('user')) {
      context.handle(
          _userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('input')) {
      context.handle(
          _inputMeta, input.isAcceptableOrUnknown(data['input']!, _inputMeta));
    } else if (isInserting) {
      context.missing(_inputMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gamelog map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Gamelog.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Gamelogs createAlias(String alias) {
    return Gamelogs(_db, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY (user) REFERENCES users (id)',
        'FOREIGN KEY (game) REFERENCES games (id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final Roles roles = Roles(this);
  late final Languages languages = Languages(this);
  late final Users users = Users(this);
  late final Statuses statuses = Statuses(this);
  late final Usersinput usersinput = Usersinput(this);
  late final Logins logins = Logins(this);
  late final Games games = Games(this);
  late final Gamelogs gamelogs = Gamelogs(this);
  Selectable<int> usersCount() {
    return customSelect('SELECT COUNT(*) FROM users',
        variables: [],
        readsFrom: {
          users,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> gamesCount() {
    return customSelect('SELECT COUNT(*) FROM games',
        variables: [],
        readsFrom: {
          games,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> getUserId(String name) {
    return customSelect('SELECT id FROM users WHERE name = :name', variables: [
      Variable<String>(name)
    ], readsFrom: {
      users,
    }).map((QueryRow row) => row.read<int>('id'));
  }

  Selectable<String?> getPassword(int id) {
    return customSelect('SELECT password FROM users WHERE id = :id',
        variables: [
          Variable<int>(id)
        ],
        readsFrom: {
          users,
        }).map((QueryRow row) => row.read<String?>('password'));
  }

  Future<int> addUser(String name, String? password) {
    return customInsert(
      'INSERT OR IGNORE INTO users (date, name, password) VALUES (strftime(\'%s\',\'now\'), :name, :password)',
      variables: [Variable<String>(name), Variable<String?>(password)],
      updates: {users},
    );
  }

  Future<int> addUserInput(int user, String input) {
    return customInsert(
      'INSERT INTO usersinput (date, user, input) VALUES (strftime(\'%s\',\'now\'), :user, :input)',
      variables: [Variable<int>(user), Variable<String>(input)],
      updates: {usersinput},
    );
  }

  Future<int> addUserLogin(int user, int connection) {
    return customInsert(
      'INSERT INTO logins (date, user, connection) VALUES (strftime(\'%s\',\'now\'), :user, :connection)',
      variables: [Variable<int>(user), Variable<int>(connection)],
      updates: {logins},
    );
  }

  Future<int> addGame(int player1, int player2) {
    return customInsert(
      'INSERT INTO games (datestarted, player1, player2) VALUES (strftime(\'%s\',\'now\'), :player1, :player2)',
      variables: [Variable<int>(player1), Variable<int>(player2)],
      updates: {games},
    );
  }

  Future<int> setGameResult(int result, int? winner, int? looser, int id) {
    return customUpdate(
      'UPDATE games SET datefinished = strftime(\'%s\',\'now\'), result = :result, winner = :winner, looser = :looser WHERE id = :id',
      variables: [
        Variable<int>(result),
        Variable<int?>(winner),
        Variable<int?>(looser),
        Variable<int>(id)
      ],
      updates: {games},
      updateKind: UpdateKind.update,
    );
  }

  Future<int> addInGameUserInput(
      int game, int user, String input, String result) {
    return customInsert(
      'INSERT INTO gamelogs (date, game, user, input, result) VALUES (strftime(\'%s\',\'now\'), :game, :user, :input, :result)',
      variables: [
        Variable<int>(game),
        Variable<int>(user),
        Variable<String>(input),
        Variable<String>(result)
      ],
      updates: {gamelogs},
    );
  }

  Selectable<PersonalEncountersResult> personalEncounters(
      int player1id, int player2id) {
    return customSelect(
        'SELECT player1, player2, result, winner, looser, COUNT(winner) AS wins\r\n					FROM games\r\n					WHERE (games.player1 = :player1id OR games.player1 = :player2id) AND (games.player2 = :player1id OR games.player2 = :player2id) AND result > 0\r\n					GROUP BY winner',
        variables: [
          Variable<int>(player1id),
          Variable<int>(player2id)
        ],
        readsFrom: {
          games,
        }).map((QueryRow row) {
      return PersonalEncountersResult(
        player1: row.read<int>('player1'),
        player2: row.read<int>('player2'),
        result: row.read<int>('result'),
        winner: row.read<int?>('winner'),
        looser: row.read<int?>('looser'),
        wins: row.read<int>('wins'),
      );
    });
  }

  Selectable<PlayerGamesResult> playerGames(int playerid) {
    return customSelect(
        'SELECT	datetime(datestarted, \'unixepoch\') AS start_time,\r\n							datetime(datefinished, \'unixepoch\') AS finish_time,\r\n							time(datefinished - datestarted, \'unixepoch\') AS duration,\r\n							CASE games.player1\r\n								WHEN :playerid\r\n								THEN games.player2\r\n								ELSE games.player1\r\n							END enemy,\r\n							enemy.name as enemyname,\r\n							winner,\r\n							winner.name as winnername,\r\n							looser,\r\n							looser.name as loosername,\r\n							games.result\r\n					FROM games, users winner, users looser, users enemy\r\n					WHERE (games.player1 = :playerid OR games.player2 = :playerid) AND (enemy.id = enemy) AND games.winner = winner.id AND games.looser = looser.id AND result > 0\r\n					ORDER BY start_time DESC',
        variables: [
          Variable<int>(playerid)
        ],
        readsFrom: {
          games,
          users,
        }).map((QueryRow row) {
      return PlayerGamesResult(
        startTime: row.read<String>('start_time'),
        finishTime: row.read<String>('finish_time'),
        duration: row.read<String>('duration'),
        enemy: row.read<int>('enemy'),
        enemyname: row.read<String>('enemyname'),
        winner: row.read<int?>('winner'),
        winnername: row.read<String>('winnername'),
        looser: row.read<int?>('looser'),
        loosername: row.read<String>('loosername'),
        result: row.read<int>('result'),
      );
    });
  }

  Selectable<int> getPlayerWins(int? playerid) {
    return customSelect(
        'SELECT count() as wins FROM games WHERE winner = :playerid',
        variables: [
          Variable<int?>(playerid)
        ],
        readsFrom: {
          games,
        }).map((QueryRow row) => row.read<int>('wins'));
  }

  Selectable<Language> getPlayerLanguage(int playerid) {
    return customSelect(
        'SELECT languages.id, languages.short, languages.long, languages.native FROM users, languages WHERE users.id = :playerid AND languages.id = users.language',
        variables: [
          Variable<int>(playerid)
        ],
        readsFrom: {
          languages,
          users,
        }).map(languages.mapFromRow);
  }

  Selectable<Language> getLanguage(String language) {
    return customSelect(
        'SELECT id, short, long, native from languages WHERE id = :language OR short = :language OR long = :language OR native = :language',
        variables: [
          Variable<String>(language)
        ],
        readsFrom: {
          languages,
        }).map(languages.mapFromRow);
  }

  Future<int> setPlayerLanguage(int languageid, int playerid) {
    return customUpdate(
      'UPDATE users SET language = :languageid WHERE id = :playerid',
      variables: [Variable<int>(languageid), Variable<int>(playerid)],
      updates: {users},
      updateKind: UpdateKind.update,
    );
  }

  Selectable<Language> getAvailableLanguages() {
    return customSelect('SELECT * FROM languages', variables: [], readsFrom: {
      languages,
    }).map(languages.mapFromRow);
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [roles, languages, users, statuses, usersinput, logins, games, gamelogs];
}

class PersonalEncountersResult {
  final int player1;
  final int player2;
  final int result;
  final int? winner;
  final int? looser;
  final int wins;
  PersonalEncountersResult({
    required this.player1,
    required this.player2,
    required this.result,
    this.winner,
    this.looser,
    required this.wins,
  });
}

class PlayerGamesResult {
  final String startTime;
  final String finishTime;
  final String duration;
  final int enemy;
  final String enemyname;
  final int? winner;
  final String winnername;
  final int? looser;
  final String loosername;
  final int result;
  PlayerGamesResult({
    required this.startTime,
    required this.finishTime,
    required this.duration,
    required this.enemy,
    required this.enemyname,
    this.winner,
    required this.winnername,
    this.looser,
    required this.loosername,
    required this.result,
  });
}
