import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'ar';

  /// Get the saved language preference
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  /// Save the language preference
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get the default language
  static String get defaultLanguage => _defaultLanguage;

  /// Check if the language is Arabic
  static bool isArabic(String languageCode) => languageCode == 'ar';

  /// Check if the language is English
  static bool isEnglish(String languageCode) => languageCode == 'en';

  /// Get supported languages
  static List<LanguageOption> get supportedLanguages => [
    LanguageOption(
      code: 'ar',
      name: 'العربية',
      englishName: 'Arabic',
      flag: '🇸🇦',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      englishName: 'English',
      flag: '🇺🇸',
    ),
  ];
}

class LanguageOption {
  final String code;
  final String name;
  final String englishName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.englishName,
    required this.flag,
  });
}
