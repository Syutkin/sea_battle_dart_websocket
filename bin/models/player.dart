import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../database/database.dart';
import '../database/database_bloc.dart';
import 'connection.dart';
import 'field.dart';
import 'password.dart';
import 'player_state.dart';
import '../i18n/localizations.dart';
import 'ship.dart';

class Player extends Cubit<PlayerState> {
  String? name;
  int? id;
  bool _authentification = false;
  String? password;
  PlayerField playerField;
  BattleField battleField;

  // Default language is English
  Language _language =
      Language(id: 0, short: 'en', long: 'english', native: 'english');

  late String _canonicalLocale;

  PlayerState previousState = PlayerConnecting();

  final Connection connection;

  final DatabaseBloc _dbBloc;

  Timer? _disconnectTimer;

  DurationLocale _durationLocale = EnglishDurationLocale();

  StreamController<String> playerIngameInput =
      StreamController<String>.broadcast();

  Player(this.connection)
      : playerField = PlayerField(),
        battleField = BattleField(),
        _dbBloc = DatabaseBloc(),
        super(PlayerConnecting()) {
    _canonicalLocale = Intl.canonicalizedLocale(_language.short);
  }

  @override
  void onChange(Change<PlayerState> change) {
    super.onChange(change);

    previousState = change.currentState;

    if (change.nextState is PlayerEnteringName) {
      sendLocalized(() => ServerI18n.enterName);
    }

    if (change.nextState is PlayerInMenu) {
      sendLocalized(() => ServerI18n.mainMenu);
    }

    if (change.nextState is PlayerInQueue) {
      sendLocalized(() => ServerI18n.inQueue);
    }

    if (change.nextState is PlayerSelectingShipsPlacement) {
      playerField.init();
      sendLocalized(() => GameI18n.howtoPlaceShips);
    }

    if (change.nextState is PlayerSelectShipStart) {
      var ship = playerField.nextShip;
      if (ship != null) {
        send(playerField.toString());
        sendLocalized(() => GameI18n.placingShip(
            ship.size.integer, playerField.countShips(ship.size)));
        sendLocalized(() => GameI18n.shipStartPoint);
      }
    }

    if (change.nextState is PlayerSelectShipOrientation) {
      sendLocalized(() => GameI18n.shipOrientation);
    }

    if (change.nextState is PlayerPlacingShipsConfimation) {
      send(playerField.toString());
      sendLocalized(() => GameI18n.confirmShipsPlacement);
    }

    if (change.nextState is PlayerDoShot) {
      send(fields());
      sendLocalized(() => GameI18n.doShot);
    }

    if (change.nextState is PlayerAwaiting) {
      send(fields());
      sendLocalized(() => GameI18n.awaitingPlayer);
    }

    if (change.nextState is PlayerAuthorizing) {
      sendLocalized(() => ServerI18n.enterPassword);
    }

    if (change.nextState is PlayerRegistering) {
      sendLocalized(() => ServerI18n.createNewAccount);
    }

    if (change.nextState is PlayerSettingPassword) {
      sendLocalized(() => ServerI18n.setPassword);
    }

    if (change.nextState is PlayerRepeatingPassword) {
      sendLocalized(() => ServerI18n.repeatPassword);
    }

    if (change.nextState is PlayerDisconnected) {
      //ToDo: countdown duration to config file
      _disconnectTimer = Timer(Duration(seconds: 60), () {
        emit(PlayerRemove());
      });
    }
  }

  Language get language => _language;

  void setLanguage(Language language) {
    _language = language;
    _canonicalLocale = Intl.canonicalizedLocale(_language.short);
    _durationLocale = DurationLocale.fromLanguageCode(_canonicalLocale) ??
        EnglishDurationLocale();
  }

  DurationLocale get durationLocale => _durationLocale;

  bool get isAlive {
    return playerField.isShipsExists;
  }

  void copyFromPlayer(Player player) {
    playerField = player.playerField;
    battleField = player.battleField;
    _language = player.language;

    if (player.state is PlayerDisconnected) {
      emit(player.previousState);
    } else {
      emit(PlayerInMenu());
    }
  }

  bool get isAuthenticated => _authentification;

  Future<bool> authentification(String password) async {
    if (hash(password, name!) == await _dbBloc.getPassword(id!)) {
      _authentification = true;
      setLanguage(await _dbBloc.db.getPlayerLanguage(id!).getSingle());
    } else {
      _authentification = false;
    }
    return _authentification;
  }

  void init() {
    playerField.init();
    battleField.initField();
  }

  /// Send current menu to player
  void showMenu() {
    if (state is PlayerInMenu) {
      sendLocalized(() => ServerI18n.mainMenu);
    }
  }

  /// Send [message] to player
  void send(String message) {
    connection.webSocket.sink.add(message);
  }

  /// Send localized message to player
  void sendLocalized<T>(T Function() function) {
    connection.webSocket.sink
        .add(runZoned(function, zoneValues: {#Intl.locale: _canonicalLocale}));
  }

  String fields() {
    var field = <String>[];
    var playerFieldList = playerField.toList();
    var battleFieldList = battleField.toList();
    for (var i = 0; i < playerFieldList.length; i++) {
      field.add(battleFieldList[i] + '     ' + playerFieldList[i]);
    }
    return field.join('\r\n');
  }

  @override
  Future<void> close() {
    _disconnectTimer?.cancel();
    playerIngameInput.done;
    connection.webSocket.sink
        .close(status.normalClosure, 'Another peer connected');
    return super.close();
  }
}
