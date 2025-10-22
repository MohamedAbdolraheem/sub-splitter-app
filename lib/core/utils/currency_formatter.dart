import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String _currencyCode = 'SAR';
  static const String _currencySymbol = 'ر.س';

  static String format(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'ar_SA', // Saudi Arabia locale
      symbol: showSymbol ? _currencySymbol : '',
      decimalDigits: 2,
    );

    return formatter.format(amount);
  }

  static String formatCompact(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat.compactCurrency(
      locale: 'ar_SA',
      symbol: showSymbol ? _currencySymbol : '',
      decimalDigits: 1,
    );

    return formatter.format(amount);
  }

  static String get currencySymbol => _currencySymbol;
  static String get currencyCode => _currencyCode;

  // Format for display in cards/summaries
  static String formatDisplay(double amount) {
    if (amount >= 1000) {
      return formatCompact(amount);
    } else {
      return format(amount);
    }
  }

  // Format for input fields
  static String formatInput(double amount) {
    return format(amount, showSymbol: false);
  }
}
