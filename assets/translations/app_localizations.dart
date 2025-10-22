import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Subscription Splitter'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Split expenses, share subscriptions'**
  String get appTagline;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get subscriptions;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signUpWithGoogle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @profileComplete.
  ///
  /// In en, this message translates to:
  /// **'Profile Complete'**
  String get profileComplete;

  /// No description provided for @profileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get profileIncomplete;

  /// No description provided for @noAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'No additional information'**
  String get noAdditionalInfo;

  /// No description provided for @completeProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to add more details'**
  String get completeProfileMessage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @manageSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Manage your shared subscriptions and split expenses'**
  String get manageSubscriptions;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'You Owe'**
  String get youOwe;

  /// No description provided for @owedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to You'**
  String get owedToYou;

  /// No description provided for @pendingInvites.
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payments'**
  String get upcomingPayments;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @joinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get joinGroup;

  /// No description provided for @groupDetails.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get groupDetails;

  /// No description provided for @groupInformation.
  ///
  /// In en, this message translates to:
  /// **'Group Information'**
  String get groupInformation;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @billingCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing Cycle'**
  String get billingCycle;

  /// No description provided for @nextRenewal.
  ///
  /// In en, this message translates to:
  /// **'Next Renewal'**
  String get nextRenewal;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get groupMembers;

  /// No description provided for @manageMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage Members'**
  String get manageMembers;

  /// No description provided for @groupSettings.
  ///
  /// In en, this message translates to:
  /// **'Group Settings'**
  String get groupSettings;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get noMembersYet;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get noGroupsYet;

  /// No description provided for @noGroupsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a group or accept an invite to get started'**
  String get noGroupsMessage;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get financialOverview;

  /// No description provided for @totalGroups.
  ///
  /// In en, this message translates to:
  /// **'Total Groups'**
  String get totalGroups;

  /// No description provided for @monthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly Cost'**
  String get monthlyCost;

  /// No description provided for @totalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings'**
  String get totalSavings;

  /// No description provided for @savingsPercentage.
  ///
  /// In en, this message translates to:
  /// **'Savings %'**
  String get savingsPercentage;

  /// No description provided for @viewGroups.
  ///
  /// In en, this message translates to:
  /// **'View Groups'**
  String get viewGroups;

  /// No description provided for @manageGroups.
  ///
  /// In en, this message translates to:
  /// **'Manage groups'**
  String get manageGroups;

  /// No description provided for @startNewSubscription.
  ///
  /// In en, this message translates to:
  /// **'Start new subscription'**
  String get startNewSubscription;

  /// No description provided for @enterInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Enter invite code'**
  String get enterInviteCode;

  /// No description provided for @upcomingRenewals.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Renewals'**
  String get upcomingRenewals;

  /// No description provided for @recentGroups.
  ///
  /// In en, this message translates to:
  /// **'Recent Groups'**
  String get recentGroups;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {count} days'**
  String get dueInDays;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get dueSoon;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @serviceId.
  ///
  /// In en, this message translates to:
  /// **'Service ID: {id}'**
  String get serviceId;

  /// No description provided for @renewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews: {day}/{month}'**
  String get renewsOn;

  /// No description provided for @noPendingInvites.
  ///
  /// In en, this message translates to:
  /// **'No pending invites'**
  String get noPendingInvites;

  /// No description provided for @pendingInvitesCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} pending invites according to the stats'**
  String get pendingInvitesCount;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get loadingDashboard;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorLoadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the dashboard'**
  String get errorLoadingDashboard;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String get inDays;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @invitedBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by {name}'**
  String get invitedBy;

  /// No description provided for @expiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires at {date}'**
  String get expiresAt;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get markAsPaid;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySymbol;

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencyCode;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signupFailed;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed'**
  String get profileUpdateFailed;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signup successful'**
  String get signupSuccess;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @profileCompleted.
  ///
  /// In en, this message translates to:
  /// **'Profile completed successfully'**
  String get profileCompleted;

  /// No description provided for @paymentMarked.
  ///
  /// In en, this message translates to:
  /// **'Payment marked successfully'**
  String get paymentMarked;

  /// No description provided for @groupJoined.
  ///
  /// In en, this message translates to:
  /// **'Group joined successfully'**
  String get groupJoined;

  /// No description provided for @inviteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invite accepted successfully'**
  String get inviteAccepted;

  /// No description provided for @inviteRejected.
  ///
  /// In en, this message translates to:
  /// **'Invite rejected successfully'**
  String get inviteRejected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
