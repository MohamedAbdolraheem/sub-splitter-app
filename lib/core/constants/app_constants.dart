class AppConstants {
  // App Information
  static const String appName = 'Subscription Splitter';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl =
      'https://sub-splitter-backend-production.up.railway.app/';
  //'http://localhost:3000';
  //  baseUrl for testing in real device =  'http://192.168.110.253:3000';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Hive Box Names
  static const String userBox = 'user_box';
  static const String subscriptionBox = 'subscription_box';
  static const String expenseBox = 'expense_box';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
}
