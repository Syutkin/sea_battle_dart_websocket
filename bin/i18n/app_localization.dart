import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'messages_all.dart';

class AppLocalization {
  static final List<Locale> supportedLocales = [
    Locale.parse('ru'),
    Locale.parse('en'),
  ];

  static Future<AppLocalization> load(Locale locale) async {
    final localeName = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : locale.toString();

    final canonicalLocaleName = Intl.canonicalizedLocale(localeName);

    Intl.defaultLocale = canonicalLocaleName;

    await initializeMessages(localeName);
    await initializeDateFormatting(localeName);

    return AppLocalization();
  }
}
