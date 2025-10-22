import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, {String? locale}) {
    final formatter = DateFormat('dd/MM/yyyy', locale ?? 'ar_SA');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date, {String? locale}) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm', locale ?? 'ar_SA');
    return formatter.format(date);
  }

  static String formatRelativeDate(DateTime date, {String? locale}) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'اليوم'; // Today in Arabic
    } else if (difference == 1) {
      return 'غداً'; // Tomorrow in Arabic
    } else if (difference == -1) {
      return 'أمس'; // Yesterday in Arabic
    } else if (difference > 0) {
      return 'خلال $difference أيام'; // In X days in Arabic
    } else {
      return 'منذ ${difference.abs()} أيام'; // X days ago in Arabic
    }
  }

  static String formatRelativeDateEnglish(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }

  static String formatBillingDate(DateTime date, {bool isArabic = true}) {
    if (isArabic) {
      return formatRelativeDate(date);
    } else {
      return formatRelativeDateEnglish(date);
    }
  }

  static String formatInviteDate(DateTime date, {bool isArabic = true}) {
    final formatter = DateFormat('dd MMM yyyy', isArabic ? 'ar_SA' : 'en_US');
    return formatter.format(date);
  }
}
