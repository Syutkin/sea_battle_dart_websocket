import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  int connectionId;
  WebSocketChannel webSocket;

  Connection({required this.connectionId, required this.webSocket});
}
