// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final int id;
  final int date;
  final String name;
  final String? password;
  User(
      {required this.id,
      required this.date,
      required this.name,
      this.password});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
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
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String?>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String?>(password),
    };
  }

  User copyWith({int? id, int? date, String? name, String? password}) => User(
        id: id ?? this.id,
        date: date ?? this.date,
        name: name ?? this.name,
        password: password ?? this.password,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(date.hashCode, $mrjc(name.hashCode, password.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.date == this.date &&
          other.name == this.name &&
          other.password == this.password);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<int> date;
  final Value<String> name;
  final Value<String?> password;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required String name,
    this.password = const Value.absent(),
  })  : date = Value(date),
        name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<String>? name,
    Expression<String?>? password,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<int>? date,
      Value<String>? name,
      Value<String?>? password}) {
    return UsersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      password: password ?? this.password,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('password: $password')
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
  @override
  List<GeneratedColumn> get $columns => [id, date, name, password];
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Users createAlias(String alias) {
    return Users(_db, alias);
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
  factory userinput.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return userinput(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      user: serializer.fromJson<int>(json['user']),
      input: serializer.fromJson<String>(json['input']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(date.hashCode, $mrjc(user.hashCode, input.hashCode))));
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
    return userinput.fromData(data, _db,
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
  factory Login.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Login(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      user: serializer.fromJson<int>(json['user']),
      connection: serializer.fromJson<int>(json['connection']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(date.hashCode, $mrjc(user.hashCode, connection.hashCode))));
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
    return Login.fromData(data, _db,
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
  factory Game.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          datestarted.hashCode,
          $mrjc(
              player1.hashCode,
              $mrjc(
                  player2.hashCode,
                  $mrjc(
                      datefinished.hashCode,
                      $mrjc(result.hashCode,
                          $mrjc(winner.hashCode, looser.hashCode))))))));
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
    return Game.fromData(data, _db,
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
  factory Gamelog.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          date.hashCode,
          $mrjc(game.hashCode,
              $mrjc(user.hashCode, $mrjc(input.hashCode, result.hashCode))))));
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
    return Gamelog.fromData(data, _db,
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
  late final Users users = Users(this);
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

  Future<int> setGameResult(int result, int? winner, int? looser, int? id) {
    return customUpdate(
      'UPDATE games SET datefinished = strftime(\'%s\',\'now\'), result = :result, winner = :winner, looser = :looser WHERE id = :id',
      variables: [
        Variable<int>(result),
        Variable<int?>(winner),
        Variable<int?>(looser),
        Variable<int?>(id)
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

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, usersinput, logins, games, gamelogs];
}
