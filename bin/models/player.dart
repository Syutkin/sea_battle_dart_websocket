import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../database/database.dart';
import '../database/database_bloc.dart';
import 'connection.dart';
import 'field.dart';
import 'input.dart';
import 'player_state.dart';
import '../i18n/localizations.dart';
import 'ship.dart';

class Player extends Cubit<PlayerState> {
  String name;
  int id;
  PlayerField playerField;
  BattleField battleField;

  late Language _language;

  late String _canonicalLocale;

  PlayerState previousState = PlayerInitial();

  final Connection connection;

  final DatabaseBloc _dbBloc = DatabaseBloc();

  Timer? _disconnectTimer;

  DurationLocale _durationLocale = EnglishDurationLocale();

  StreamController<String> playerIngameInput =
      StreamController<String>.broadcast();

  Player({required this.connection, required this.id, required this.name})
      : playerField = PlayerField(),
        battleField = BattleField(),
        super(PlayerInitial()) {
    // read config from db (now only language)
    _dbBloc.db
        .getPlayerLanguage(id)
        .getSingle()
        .then((value) => setLanguage(value));
    // subscription to user input after authorization
    connection.playerInput.stream.listen((message) {
      message = message.toString().trim();
      Input.handleMessageFromPlayer(this, message);
    }).onDone(() {
      emit(PlayerDisconnected());
    });
  }

  @override
  void onChange(Change<PlayerState> change) {
    super.onChange(change);

    previousState = change.currentState;

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
    playerIngameInput.close();
    connection.webSocket.sink
        .close(status.normalClosure, 'Another peer connected');
    return super.close();
  }
}
