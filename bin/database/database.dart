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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration to 2
          if (from < 2) {
            // added user roles and statuses
            await m.createTable(roles);
            await m.createTable(statuses);
            await m.addColumn(users, users.role);
          }
          // Migration to 3
          if (from < 3) {
            // add user preferred language and status
            await m.createTable(languages);
            await m.addColumn(users, users.status);
            await m.addColumn(users, users.language);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated || (details.hadUpgrade)) {
            var before = details.versionBefore ?? 1;
            //populate roles and statuses
            if (before < 2) {
              await into(roles).insert(Role(id: 0, name: 'user'));
              await into(roles).insert(Role(id: 1, name: 'root'));
              await into(roles).insert(Role(id: 2, name: 'administrator'));
              await into(roles).insert(Role(id: 3, name: 'moderator'));
              await into(statuses).insert(status(id: 0, name: 'active'));
              await into(statuses).insert(status(id: 1, name: 'banned'));
            }
            if (before < 3) {
              await into(languages).insert(Language(
                id: 0,
                short: 'en',
                long: 'english',
                native: 'english',
              ));
              await into(languages).insert(Language(
                id: 1,
                short: 'ru',
                long: 'russian',
                native: 'русский',
              ));
            }
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
