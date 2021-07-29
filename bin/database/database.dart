import 'dart:io';

import 'package:moor/moor.dart';
// These imports are only needed to open the database
import 'package:moor/ffi.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@UseMoor(
  include: {'tables.moor'},
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final file = File(p.join('db', 'db.sqlite'));
    return VmDatabase(file);
  });
}
