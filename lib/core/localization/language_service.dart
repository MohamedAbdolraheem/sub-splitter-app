import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template language_service}
/// Service for managing app language preferences
/// {@endtemplate}
class LanguageService {
  /// {@macro language_service}
  LanguageService._();

  static final LanguageService _instance = LanguageService._();
  static LanguageService get instance => _instance;

  static const String _languageKey = 'app_language';

  /// Supported languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
  };

  /// Default language
  static const String defaultLanguage = 'en';

  /// Get current language from device or stored preference
  Future<String> getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedLanguage = prefs.getString(_languageKey);

      if (storedLanguage != null &&
          supportedLanguages.containsKey(storedLanguage)) {
        return storedLanguage;
      }

      // Fallback to device locale
      final deviceLanguage = _getDeviceLanguage();
      return supportedLanguages.containsKey(deviceLanguage)
          ? deviceLanguage
          : defaultLanguage;
    } catch (e) {
      debugPrint('Error getting current language: $e');
      return defaultLanguage;
    }
  }

  /// Set app language preference
  Future<void> setLanguage(String languageCode) async {
    try {
      if (!supportedLanguages.containsKey(languageCode)) {
        throw ArgumentError('Unsupported language: $languageCode');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  /// Get device language code
  String _getDeviceLanguage() {
    try {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      return locale.languageCode;
    } catch (e) {
      debugPrint('Error getting device language: $e');
      return defaultLanguage;
    }
  }

  /// Check if language is RTL
  bool isRTL(String languageCode) {
    return languageCode == 'ar';
  }

  /// Get language name
  String getLanguageName(String languageCode) {
    return supportedLanguages[languageCode] ?? languageCode;
  }

  /// Get all supported language codes
  List<String> getSupportedLanguageCodes() {
    return supportedLanguages.keys.toList();
  }
}
