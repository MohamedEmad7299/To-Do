
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {

  static const String _localeKey = 'app_locale';

  static const Locale englishLocale = Locale('en');
  static const Locale arabicLocale = Locale('ar');

  static const List<Locale> supportedLocales = [
    englishLocale,
    arabicLocale,
  ];

  Future<Locale?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        return Locale(languageCode);
      }
      return null;
    } catch (e) {
      print('Error getting saved locale: $e');
      return null;
    }
  }


  Future<bool> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      print('Error saving locale: $e');
      return false;
    }
  }


  Future<bool> clearLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_localeKey);
    } catch (e) {
      print('Error clearing locale: $e');
      return false;
    }
  }

  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }
}
