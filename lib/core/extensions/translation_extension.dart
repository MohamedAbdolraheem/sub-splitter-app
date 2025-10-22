import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/font_service.dart';

/// Extension on BuildContext to provide easy access to translations
extension Translation on BuildContext {
  /// Get the AppLocalizations instance
  AppLocalizations get tr =>
      AppLocalizations.of(this);

  /// Get the current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if the current locale is Arabic
  bool get isArabic => locale.languageCode == 'ar';

  /// Check if the current locale is English
  bool get isEnglish => locale.languageCode == 'en';

  /// Get text direction based on current locale
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  /// Get alignment based on current locale
  Alignment get startAlignment =>
      isArabic ? Alignment.centerRight : Alignment.centerLeft;
  Alignment get endAlignment =>
      isArabic ? Alignment.centerLeft : Alignment.centerRight;

  /// Get cross axis alignment based on current locale
  CrossAxisAlignment get startCrossAxisAlignment =>
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  CrossAxisAlignment get endCrossAxisAlignment =>
      isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end;

  /// Get main axis alignment based on current locale
  MainAxisAlignment get startMainAxisAlignment =>
      isArabic ? MainAxisAlignment.end : MainAxisAlignment.start;
  MainAxisAlignment get endMainAxisAlignment =>
      isArabic ? MainAxisAlignment.start : MainAxisAlignment.end;

  // Font utilities
  /// Get the appropriate font family for current language
  String get fontFamily => FontService.getFontFamily(this);

  /// Get Arabic font family
  String get arabicFont => FontService.arabicFont;

  /// Get English font family
  String get englishFont => FontService.englishFont;

  /// Create text style with language-appropriate font
  TextStyle textStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return FontService.getTextStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  /// Create heading text style
  TextStyle headingStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return FontService.getHeadingStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Create body text style
  TextStyle bodyStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return FontService.getBodyStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Create caption text style
  TextStyle captionStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return FontService.getCaptionStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Create button text style
  TextStyle buttonStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    return FontService.getButtonStyle(
      this,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
