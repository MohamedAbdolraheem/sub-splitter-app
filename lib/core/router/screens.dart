enum Screens {
  splash,
  login,
  signup,
  createProfile,
  settings,
  about,
  contact,
  notFound,
  unknown,
  addNewProperty,
  propertiesListAndDetails,
  addNewPropertyLocation,
  example,
  professionalHost,
  hostChatList,
  hostChat,
  homeDashboard,
  propertyDetails,
  bookingDetails,
  bookingSuccessful,
  newPropertyAddedSuccessfully,
  myReservations,
  myReservationDetails,
  myFavorites,
  imagePreview,
  financiaTransactions,
  calendar,
  rating,
  payout,
  statement,
  supportCenter,
  addComplaint,
  displayProfile,
  homeExploreMapView,
  notifications,
  privacyPolicy,
  termsAndConditions,
  deleteAccount,
  otp,
  onBoarding,
  ambassadors,
  wallet,
  hostPage,
  createGroup,
  groupDetails,
  groupSettings,
  groupMembers,
  groups,
}

extension ScreensExtension on Screens {
  // replace first uppercase letter with space and lowercase letter after first one (e.g. 'loginWithGoogle' -> 'login with google')
  String get name {
    final name = toString().split('.').last;
    return name
        .replaceAllMapped(
          RegExp('([A-Z])'),
          (match) => ' ${match.group(0)!.toLowerCase()}',
        )
        .trim();
  }

  String convertToPath(String input) {
    return '/${input.replaceFirstMapped(RegExp('[A-Z]'), (match) => '-${match.group(0)!.toLowerCase()}')}';
  }

  String get path {
    final name = toString().split('.').last;
    switch (name) {
      case 'groupDetails':
        return '/group-details/:groupId';
      case 'groupSettings':
        return '/group-settings/:groupId';
      case 'groupMembers':
        return '/group-members/:groupId';
      case 'groups':
        return '/groups';
      default:
        return convertToPath(name);
    }
  }
}
