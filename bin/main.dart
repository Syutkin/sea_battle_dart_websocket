import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';

import 'db/database.dart';
import 'models/server.dart';

const serverVersion = '1.0.1';

void main(List<String> arguments) {
  const urlParamName = 'url';
  const defaultUrl = 'ws://127.0.0.1:9224';
  const helpParamName = 'help';
  const versionParamName = 'version';

  // for ansi color output
  ansiColorDisabled = false;

  final parser = ArgParser();

  parser.addSeparator('Sea Battle server $serverVersion.\n\n'
      'Usage: sea_battle_server [--version] [--help] [--url=<url>]\n\n'
      'Global options:');

  parser.addFlag(
    helpParamName,
    abbr: 'h',
    help: 'show this screen and exit',
    negatable: false,
  );

  parser.addFlag(
    versionParamName,
    abbr: 'v',
    help: 'show version and exit',
    negatable: false,
  );

  parser.addOption(
    urlParamName,
    abbr: 'u',
    defaultsTo: defaultUrl,
    valueHelp: urlParamName,
    help: 'start and bind server to protocol://ip:port\n'
        'where protocol can be ws or wss',
  );

  var argResults = parser.parse(arguments);

  if (argResults[helpParamName]) {
    print(parser.usage);
    return;
  }

  if (argResults[versionParamName]) {
    print('Sea Battle server: version $serverVersion');
    return;
  }

  print('Starting Sea Battle server, version $serverVersion');
  var uri = Uri.tryParse(argResults[urlParamName]) ?? Uri.parse(defaultUrl);
  Server.bind(address: uri.host, port: uri.port);
}
