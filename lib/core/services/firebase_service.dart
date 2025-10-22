import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase Analytics
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  // Firebase Crashlytics
  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  // Firebase Messaging
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // Analytics Methods
  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  static Future<void> setUserId(String userId) async {
    try {
      await analytics.setUserId(id: userId);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics setUserId error: $e');
      }
    }
  }

  static Future<void> setUserProperty(String name, String value) async {
    try {
      await analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics setUserProperty error: $e');
      }
    }
  }

  // Crashlytics Methods
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    try {
      await crashlytics.recordError(exception, stackTrace, reason: reason);
    } catch (e) {
      if (kDebugMode) {
        print('Crashlytics error: $e');
      }
    }
  }

  static Future<void> setCustomKey(String key, Object value) async {
    try {
      await crashlytics.setCustomKey(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Crashlytics setCustomKey error: $e');
      }
    }
  }

  static Future<void> setCrashlyticsUserId(String userId) async {
    try {
      await crashlytics.setUserIdentifier(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Crashlytics setUserIdentifier error: $e');
      }
    }
  }

 

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await messaging.subscribeToTopic(topic);
    } catch (e) {
      if (kDebugMode) {
        print('FCM subscribeToTopic error: $e');
      }
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      if (kDebugMode) {
        print('FCM unsubscribeFromTopic error: $e');
      }
    }
  }

  // Common Events for Subscription Splitter App
  static Future<void> logUserSignUp(String method) async {
    await logEvent('user_sign_up', parameters: {'method': method});
  }

  static Future<void> logUserSignIn(String method) async {
    await logEvent('user_sign_in', parameters: {'method': method});
  }

  static Future<void> logUserSignOut() async {
    await logEvent('user_sign_out');
  }

  static Future<void> logSubscriptionCreated(String subscriptionId) async {
    await logEvent(
      'subscription_created',
      parameters: {'subscription_id': subscriptionId},
    );
  }

  static Future<void> logExpenseCreated(String expenseId) async {
    await logEvent('expense_created', parameters: {'expense_id': expenseId});
  }

  static Future<void> logPaymentProcessed(
    String paymentId,
    double amount,
  ) async {
    await logEvent(
      'payment_processed',
      parameters: {'payment_id': paymentId, 'amount': amount},
    );
  }
}
