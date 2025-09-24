import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'translations.g.dart';

mixin DesignTranslationMixin on Cubit<Locale> {
  /// Get the current translations based on the locale state
  Translations get design {
    final currentLocale = _parseLocale(state);
    return currentLocale.build();
  }

  /// Parse Flutter Locale to AppLocale enum
  AppLocale _parseLocale(Locale locale) {
    try {
      return AppLocaleUtils.parse(locale.languageCode);
    } catch (e) {
      // Fallback to base locale if parsing fails
      return AppLocale.en;
    }
  }

  /// Set the locale and update the global locale settings
  void setLocale(AppLocale locale) {
    LocaleSettings.setLocale(locale);
    emit(locale.flutterLocale);
  }

  /// Get supported locales
  List<Locale> get supportedLocales => AppLocaleUtils.supportedLocales;

  /// Check if a locale is supported
  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) => 
      supportedLocale.languageCode == locale.languageCode,);
  }
}
