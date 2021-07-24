import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';

import 'models/server.dart';

void main(List<String> arguments) {
  const urlParamName = 'url';
  const defaultUrl = 'ws://127.0.0.1:9224';

  final parser = ArgParser()..addOption(urlParamName, defaultsTo: defaultUrl);

  var argResults = parser.parse(arguments);

  var uri = Uri.tryParse(argResults[urlParamName]) ?? Uri.parse(defaultUrl);

  ansiColorDisabled = false;

  Server.bind(uri.host, uri.port);
}
