import 'package:flutter/material.dart';

class FontService {
  // Font families
  static const String cairoFont = 'Cairo';
  static const String loraFont = 'Lora';

  // Get the appropriate font family based on locale
  static String getFontFamily(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? cairoFont : loraFont;
  }

  // Get font family for Arabic
  static String get arabicFont => cairoFont;

  // Get font family for English
  static String get englishFont => loraFont;

  /// Returns the appropriate font family based on language code.
  static String getFontFamilyByLanguage(String languageCode) {
    return languageCode == 'ar' ? cairoFont : loraFont;
  }

  // Create text style with language-appropriate font
  static TextStyle getTextStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(context),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Create heading text style
  static TextStyle getHeadingStyle(
    BuildContext context, {
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return getTextStyle(
      context,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Create body text style
  static TextStyle getBodyStyle(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return getTextStyle(
      context,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Create caption text style
  static TextStyle getCaptionStyle(
    BuildContext context, {
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return getTextStyle(
      context,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Create button text style
  static TextStyle getButtonStyle(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    return getTextStyle(
      context,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
