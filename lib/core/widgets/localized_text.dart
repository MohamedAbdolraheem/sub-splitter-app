import 'package:flutter/material.dart';
import '../theme/font_service.dart';

/// A text widget that automatically uses the correct font based on the current language
class LocalizedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? height;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const LocalizedText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.height,
    this.textAlign,
    this.decoration,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: FontService.getTextStyle(
        context,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        decoration: decoration,
      ).merge(style),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A heading text widget with language-appropriate font
class LocalizedHeading extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedHeading(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A body text widget with language-appropriate font
class LocalizedBodyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedBodyText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A caption text widget with language-appropriate font
class LocalizedCaption extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedCaption(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A button text widget with language-appropriate font
class LocalizedButtonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const LocalizedButtonText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
    );
  }
}
