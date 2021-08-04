import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@UseMoor(
  include: {'tables.moor'},
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // added user roles and statuses
            await m.createTable(roles);
            await m.createTable(statuses);
            await m.addColumn(users, users.role);
          }
        },
        beforeOpen: (details) async {
          //populate roles and statuses
          if (details.wasCreated ||
              (details.hadUpgrade && details.versionBefore == 1)) {
            await into(roles).insert(Role(id: 0, name: 'user'));
            await into(roles).insert(Role(id: 1, name: 'root'));
            await into(roles).insert(Role(id: 2, name: 'administrator'));
            await into(roles).insert(Role(id: 3, name: 'moderator'));
            await into(statuses).insert(status(id: 0, name: 'active'));
            await into(statuses).insert(status(id: 1, name: 'banned'));
          }
        },
      );
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final file = File(p.join('db', 'db.sqlite'));
    return VmDatabase(file);
  });
}
