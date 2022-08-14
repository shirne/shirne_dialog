import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kShirneDialogSupportedLanguages = {'en', 'zh'};

abstract class ShirneDialogLocalizations {
  static const LocalizationsDelegate<ShirneDialogLocalizations> delegate =
      _ShirneDialogLocalizationsDelegate();

  static ShirneDialogLocalizations of(BuildContext context) =>
      Localizations.of<ShirneDialogLocalizations>(
          context, ShirneDialogLocalizations)!;

  String get buttonConfirm;
  String get buttonCancel;
  String get closeSemantics;
}

class _ShirneDialogLocalizationsDelegate
    extends LocalizationsDelegate<ShirneDialogLocalizations> {
  const _ShirneDialogLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kShirneDialogSupportedLanguages.contains(locale.languageCode);

  static final Map<Locale, Future<ShirneDialogLocalizations>>
      _loadedTranslations = <Locale, Future<ShirneDialogLocalizations>>{};

  @override
  Future<ShirneDialogLocalizations> load(Locale locale) {
    return _loadedTranslations.putIfAbsent(
        locale,
        () => SynchronousFuture<ShirneDialogLocalizations>(
            _getTranslation(locale)));
  }

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<ShirneDialogLocalizations> old) =>
      false;

  static ShirneDialogLocalizations _getTranslation(Locale locale) {
    switch (locale.languageCode) {
      case 'cn':
        return ShirneDialogLocalizationsCn();
      case 'en':
      default:
        return ShirneDialogLocalizationsEn();
    }
  }
}

class ShirneDialogLocalizationsCn extends ShirneDialogLocalizations {
  @override
  String get buttonCancel => '取消';

  @override
  String get buttonConfirm => '确定';

  @override
  String get closeSemantics => '关闭';
}

class ShirneDialogLocalizationsEn extends ShirneDialogLocalizations {
  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonConfirm => 'Confirm';

  @override
  String get closeSemantics => 'Close';
}
