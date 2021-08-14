import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../database/database_bloc.dart';
import '../i18n/localizations.dart';
import 'connection_state.dart';
import 'password.dart';

class Connection extends Cubit<ConnectionState> {
  int connectionId;
  WebSocketChannel webSocket;

  final DatabaseBloc _dbBloc = DatabaseBloc();

  //ToDo: default server locale to config file
  final _canonicalLocale = Intl.canonicalizedLocale('en');

  int? playerId;
  String? playerName;
  String? password;
  bool _authentification = false;

  StreamController<String> playerInput = StreamController<String>.broadcast();

  Connection({required this.connectionId, required this.webSocket})
      : super(Connecting());

  @override
  void onChange(Change<ConnectionState> change) {
    super.onChange(change);

    if (change.nextState is EnteringName) {
      sendLocalized(() => ServerI18n.enterName);
    }

    if (change.nextState is Authorizing) {
      sendLocalized(() => ServerI18n.enterPassword);
    }

    if (change.nextState is Registering) {
      sendLocalized(() => ServerI18n.createNewAccount);
    }

    if (change.nextState is SettingPassword) {
      sendLocalized(() => ServerI18n.setPassword);
    }

    if (change.nextState is RepeatingPassword) {
      sendLocalized(() => ServerI18n.repeatPassword);
    }
  }

  /// Send localized message to connection
  void sendLocalized<T>(T Function() function) {
    webSocket.sink
        .add(runZoned(function, zoneValues: {#Intl.locale: _canonicalLocale}));
  }

  // bool get isAuthenticated => _authentification;

  Future<bool> authentification(String password) async {
    if (hash(password, playerName!) == await _dbBloc.getPassword(playerId!)) {
      emit(Authorized());
      _authentification = true;
    } else {
      _authentification = false;
    }
    return _authentification;
  }

  @override
  Future<void> close() {
    playerInput.close();
    return super.close();
  }
}
