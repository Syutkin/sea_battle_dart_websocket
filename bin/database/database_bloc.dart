import 'database.dart';

class DatabaseBloc {
  Database db;

  static DatabaseBloc bloc = DatabaseBloc._();

  DatabaseBloc._() : db = Database();

  factory DatabaseBloc() {
    return bloc;
  }

  Future<int> usersCount() {
    return db.usersCount().getSingle();
  }

  Future<int> gamesCount() {
    return db.gamesCount().getSingle();
  }

  Future<int?> getUserId(String name) {
    return db.getUserId(name).getSingleOrNull();
  }

  Future<String?> getPassword(int id) {
    return db.getPassword(id).getSingleOrNull();
  }

  // Future<int> addUser(String name, String? password) {
  //   return db.addUser(name, password);
  // }

  // Future<int> addUserInput(int user, String input) {
  //   return db.addUserInput(user, input);
  // }

  // Future<int> addUserLogin(int user, int connection) {
  //   return db.addUserLogin(user, connection);
  // }

  // Future<int> addGame(int player1, int player2) {
  //   return db.addGame(player1, player2);
  // }

  // Future<int> setGameResult(int result, int? winner, int? looser, int? id) {
  //   return db.setGameResult(result, winner, looser, id);
  // }

  // Future<int> addInGameUserInput(
  //     int game, int user, String input, String result) {
  //   return db.addInGameUserInput(game, user, input, result);
  // }


}
