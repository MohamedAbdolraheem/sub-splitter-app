import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  /// Private constructor for fallback instance
  AppLocalizations._(this.locale);

  static AppLocalizations of(BuildContext context) {
    try {
      return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    } catch (e) {
      // Return fallback instance if context is deactivated
      return fallback;
    }
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Fallback instance when AppLocalizations is not available
  static AppLocalizations get fallback {
    final fallback = AppLocalizations._(const Locale('en', 'US'));
    fallback._localizedStrings = <String, String>{};
    return fallback;
  }

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/translations/${locale.languageCode}.json',
      );
      _localizedStrings = json.decode(jsonString);
      return true;
    } catch (e) {
      print('Error loading translations for ${locale.languageCode}: $e');
      // Fallback to empty strings to prevent crashes
      _localizedStrings = <String, String>{};
      return false;
    }
  }

  String translate(String key, {Map<String, dynamic>? args}) {
    try {
      String value = _getNestedValue(key);

      if (args != null) {
        args.forEach((key, value) {
          value = value.replaceAll('{$key}', value.toString());
        });
      }

      return value;
    } catch (e) {
      print('Error translating key "$key": $e');
      return key; // Return the key itself as fallback
    }
  }

  String _getNestedValue(String key) {
    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // Return key if translation not found
      }
    }

    return value.toString();
  }

  // Convenience methods for common translations
  String get appName => translate('appName');
  String get appTagline => translate('appTagline');

  // Common
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get confirm => translate('confirm');
  String get back => translate('back');
  String get next => translate('next');
  String get done => translate('done');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get language => translate('language');
  String get settings => translate('settings');
  String get subscriptions => translate('subscriptions');
  String get expenses => translate('expenses');
  String get payments => translate('payments');
  String get helpSupport => translate('helpSupport');
  String get comingSoon => translate('comingSoon');
  String get signOut => translate('signOut');
  String get signOutConfirm => translate('signOutConfirm');

  // Auth
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get signup => translate('signup');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirmPassword');
  String get forgotPassword => translate('forgotPassword');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get signInWithGoogle => translate('signInWithGoogle');
  String get signUpWithGoogle => translate('signUpWithGoogle');

  // Profile
  String get profileTitle => translate('profileTitle');
  String get name => translate('name');
  String get mobile => translate('mobile');
  String get dateOfBirth => translate('dateOfBirth');
  String get gender => translate('gender');
  String get location => translate('location');
  String get bio => translate('bio');
  String get completeProfile => translate('completeProfile');
  String get editProfile => translate('editProfile');
  String get changePassword => translate('changePassword');
  String get privacySettings => translate('privacySettings');
  String get accountInfo => translate('accountInfo');
  String get profileComplete => translate('profileComplete');
  String get profileIncomplete => translate('profileIncomplete');
  String get noAdditionalInfo => translate('noAdditionalInfo');
  String get completeProfileMessage => translate('completeProfileMessage');

  // Dashboard
  String get welcomeBack => translate('welcomeBack');
  String get manageSubscriptions => translate('manageSubscriptions');
  String get youOwe => translate('youOwe');
  String get owedToYou => translate('owedToYou');
  String get pendingInvites => translate('pendingInvites');
  String get upcomingPayments => translate('upcomingPayments');
  String get myGroups => translate('myGroups');
  String get quickActions => translate('quickActions');
  String get createGroup => translate('createGroup');
  String get joinGroup => translate('joinGroup');

  // Group Details
  String get groupDetails => translate('groupDetails');
  String get groupInformation => translate('groupInformation');
  String get groupName => translate('groupName');
  String get service => translate('service');
  String get totalCost => translate('totalCost');
  String get billingCycle => translate('billingCycle');
  String get nextRenewal => translate('nextRenewal');
  String get groupMembers => translate('groupMembers');
  String get manageMembers => translate('manageMembers');
  String get groupSettings => translate('groupSettings');
  String get recentActivity => translate('recentActivity');
  String get noMembersYet => translate('noMembersYet');
  String get noRecentActivity => translate('noRecentActivity');
  String get errorOccurred => translate('errorOccurred');
  String get tryAgain => translate('tryAgain');
  String get viewAll => translate('viewAll');
  String get noGroupsYet => translate('noGroupsYet');
  String get noGroupsMessage => translate('noGroupsMessage');

  // Dashboard specific
  String get financialOverview => translate('financialOverview');
  String get totalGroups => translate('totalGroups');
  String get monthlyCost => translate('monthlyCost');
  String get totalSavings => translate('totalSavings');
  String get savingsPercentage => translate('savingsPercentage');
  String get viewGroups => translate('viewGroups');
  String get manageGroups => translate('manageGroups');
  String get startNewSubscription => translate('startNewSubscription');
  String get enterInviteCode => translate('enterInviteCode');
  String get upcomingRenewals => translate('upcomingRenewals');
  String get recentGroups => translate('recentGroups');
  String get dueToday => translate('dueToday');
  String get dueTomorrow => translate('dueTomorrow');
  String get dueInDays => translate('dueInDays');
  String get dueSoon => translate('dueSoon');
  String get active => translate('active');
  String get serviceId => translate('serviceId');
  String get renewsOn => translate('renewsOn');
  String get noPendingInvites => translate('noPendingInvites');
  String get pendingInvitesCount => translate('pendingInvitesCount');
  String get loadingDashboard => translate('loadingDashboard');
  String get somethingWentWrong => translate('somethingWentWrong');
  String get errorLoadingDashboard => translate('errorLoadingDashboard');
  String get notifications => translate('notifications');

  // Groups
  String get createNewGroup => translate('createGroup');
  String get joinGroupAction => translate('joinGroup');
  String get monthly => translate('monthly');
  String get yearly => translate('yearly');
  String get members => translate('members');
  String get owner => translate('owner');
  String get member => translate('member');
  String get paid => translate('paid');
  String get due => translate('due');
  String get overdue => translate('overdue');
  String get today => translate('today');
  String get tomorrow => translate('tomorrow');
  String get daysAgo => translate('daysAgo');
  String inDays(int count) => translate('inDays', args: {'count': count});

  // Invites
  String get accept => translate('accept');
  String get reject => translate('reject');
  String invitedBy(String name) => translate('invitedBy', args: {'name': name});
  String expiresAt(String date) => translate('expiresAt', args: {'date': date});

  // Payments
  String get markAsPaid => translate('markAsPaid');
  String get paymentHistory => translate('paymentHistory');
  String get amount => translate('amount');
  String get dueDate => translate('dueDate');
  String get status => translate('status');

  // Currency
  String get currencySymbol => translate('currencySymbol');
  String get currencyCode => translate('currencyCode');

  // Validation
  String get required => translate('required');
  String get emailInvalid => translate('emailInvalid');
  String get passwordTooShort => translate('passwordTooShort');
  String get passwordsDoNotMatch => translate('passwordsDoNotMatch');
  String get nameTooShort => translate('nameTooShort');
  String get phoneInvalid => translate('phoneInvalid');

  // Errors
  String get networkError => translate('networkError');
  String get serverError => translate('serverError');
  String get unknownError => translate('unknownError');
  String get loginFailed => translate('loginFailed');
  String get signupFailed => translate('signupFailed');
  String get profileUpdateFailed => translate('profileUpdateFailed');

  // Success
  String get loginSuccess => translate('loginSuccess');
  String get signupSuccess => translate('signupSuccess');
  String get profileUpdated => translate('profileUpdated');
  String get profileCompleted => translate('profileCompleted');
  String get paymentMarked => translate('paymentMarked');
  String get groupJoined => translate('groupJoined');
  String get inviteAccepted => translate('inviteAccepted');
  String get inviteRejected => translate('inviteRejected');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
