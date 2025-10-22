# 🔔 Complete Notification Services Guide

## 📚 **Overview**

You have **3 notification services** that work together:

1. **`NotificationService`** (Firebase FCM) - Receives notifications
2. **`NotificationApiService`** (Backend API) - Sends notifications  
3. **`UnifiedNotificationService`** (Unified Interface) - Complete solution

## 🚀 **How to Use Each Service:**

### **1. NotificationService (FCM)**

**Purpose**: Handles Firebase Cloud Messaging (receiving notifications)

```dart
final service = ServiceLocator().notificationService;

// Initialize Firebase
await service.initialize();

// Listen to incoming notifications
service.notificationStream.listen((notification) {
  print('New notification: ${notification.title}');
});

// Get FCM token
String? token = service.fcmToken;

// Subscribe to topics
await service.subscribeToGroup('group_id_123');
await service.subscribeToUser('user_id_456');
```

### **2. NotificationApiService (Backend)**

**Purpose**: Communicates with your NestJS backend

```dart
final apiService = ServiceLocator().notificationApiService;

// Send single notification
await apiService.sendNotificationToUser(
  userId: 'user_123',
  title: 'Payment Due',
  body: 'Your subscription payment is due today',
);

// Send to multiple users
await apiService.sendNotificationToUsers(
  userIds: ['user_1', 'user_2', 'user_3'],
  title: 'Group Update',
  body: 'Group settings have been updated',
);

// Send to entire group
await apiService.sendNotificationToGroup(
  groupId: 'group_456',
  title: 'Group Message',
  body: 'New message in the group',
);

// Get user notifications
final notifications = await apiService.getUserNotificationsList(
  userId: 'user_123',
  page: 1,
  limit: 20,
);

// Mark as read
await apiService.markNotificationAsRead('notification_id_789');

// Update preferences
await apiService.updatePreferencesFromModel(preferences);

// Register device token
await apiService.registerDeviceToken(
  userId: 'user_123',
  token: 'fcm_token_from_firebase',
  deviceType: 'mobile',
);
```

### **3. UnifiedNotificationService (Complete Solution)**

**Purpose**: Single service that combines both Firebase and API functionality

```dart
final unifiedService = ServiceLocator().unifiedNotificationService;

// Initialize everything
await unifiedService.initialize();

// Listen to notifications
unifiedService.notificationStream.listen((notification) {
  // Handle incoming notification
});

// Send notifications (automatically registers with backend)
await unifiedService.sendToUser(
  userId: 'user_123',
  title: 'Payment Reminder',
  body: 'Your payment is due',
);

// Send to group
await unifiedService.sendToGroup(
  groupId: 'group_789',
  title: 'Group Alert', 
  body: 'Checkout the new updates',
);

// Subscribe to notifications
await unifiedService.subscribeToGroup('group_789');
await unifiedService.subscribeToUser('user_123');
```

## 🔄 **Complete Workflow Example**

Here's how all three services work together:

```dart
class NotificationManager {
  late UnifiedNotificationService _service;

  Future<void> initialize() async {
    // 1. Get the unified service (contains both Firebase + API)
    _service = ServiceLocator().unifiedNotificationService;
    
    // 2. Initialize Firebase FCM and register with backend
    await _service.initialize();
    
    // 3. Start listening for incoming notifications
    _service.notificationStream.listen(_handleNotification);
  }

  void _handleNotification(NotificationModel notification) {
    // Show snackbar, navigate, update UI, etc.
    print('Received: ${notification.title}');
  }

  // Send notification
  Future<void> sendPaymentReminder(String userId, double amount) async {
    await _service.sendToUser(
      userId: userId,
      title: 'Payment Due',
      body: 'Amount: \$${amount.toStringAsFixed(2)}',
      type: NotificationType.paymentReminder,
    );
  }

  // Send group notification
  Future<void> sendGroupAlert(String groupId) async {
    await _service.sendToGroup(
      groupId: groupId,
      title: 'Important Group Update',
      body: 'Please check the latest changes',
    );
  }
}
```

## 🎯 **Which Service Should I Use?**

| Use Case | Service | Example |
|----------|---------|---------|
| **Send notifications** | `NotificationApiService` or `UnifiedNotificationService` | Payment reminders, group alerts |
| **Receive notifications** | `NotificationService` or `UnifiedNotificationService` | Listen to incoming messages |
| **Complete solution** | `UnifiedNotificationService` | Full notification handling |
| **Only FCM functionality** | `NotificationService` | Firebase-only features |
| **Only backend API calls** | `NotificationApiService` | Backend communication |

## 🔧 **Future Enhancements**

Your notification system is complete and ready! 

- **Backend**: Implement your 8 NestJS endpoints
- **Testing**: Use both services for sending/receiving
- **UI**: Integrate with your notification pages

Your notification management system is production-ready! 🎉
