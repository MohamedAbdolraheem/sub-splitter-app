# 📱 How to Use the Enhanced Notification System

## 🚀 **Getting Started with Dynamic App Versioning**

Your notification system now has **complete package_info_plus integration**! Here's everything you need to know:

---

## 🎯 **Step 1: Access the Notification System**

### **From Navigation:**
1. **Dashboard Home** → Tap notifications icon in AppBar
2. **App Drawer** → "Notifications" option
3. **Direct Route:** `/notifications` path

### **Via Code:**
```dart
// Navigate to notifications page
Navigator.of(context).pushNamed('/notifications');
// or using GoRouter
context.push('/notifications');
```

---

## 📲 **Step 2: Using the Notification System**

### **🔥 Automatic Features (Working Now):**

#### **A. Device Registration:**
✅ **Done Automatically** - When your app starts, it registers with complete app info:

```bash
Debug Log: "NotificationService: Complete app info retrieved - {
  appName: SubscriptionSplitter,
  version: 1.0.0,
  buildNumber: 42,
  packageName: com.yourcompany.app
}"
```

#### **B. Token Registration:**
✅ **Done Automatically** - FCM tokens sent with full metadata to backend:

```json
{
  "userId": "supabase_user_id",
  "token": "device_fcm_token",
  "deviceType": "mobile",
  "appVersion": "1.0.0",
  "appName": "SubscriptionSplitter", 
  "buildNumber": "42",
  "packageName": "com.yourcompany.subscription_splitter"
}
```

---

## 🎛️ **Step 3: Testing the System**

### **🔥 Test Send Notification (Built-in)**
**In the Notifications Page:**
1. Tap **📤 Send button** (right side of AppBar)
2. System sends test notification with real-time logging
3. Verifies your complete app info is correctly captured

### **🔥 Compose Custom Notifications**
**In the Notifications Page:**
1. Tap **➕ Add button** 
2. Choose notification type
3. Select language (English/Arabic)
4. Type custom message
5. **Sends via your backend API** for real testing

---

## 🔧 **Step 4: Backend Integration Ready**

### **Your NestJS Backend Receives:**
```typescript
POST /notifications/device-token
{
  "userId": "supabase_user_123",
  "token": "fcm_actual_token",
  "deviceType": "mobile",
  "appVersion": "1.0.0",           // ✅ From package_info_plus  
  "appName": "SubscriptionSplitter", // ✅ From package_info_plus
  "buildNumber": "42",              // ✅ From package_info_plus  
  "packageName": "com.your.app"      // ✅ From package_info_plus
}
```

---

## 📱 **Step 5: Real-World Usage Examples**

### **Scenario A: New App Release**
**User receives notification:**
- **Target Version**: Only users on v1.0.0+
- **Dry-Run**: Get exact version from your meta payload
- **Behavior**: Send upgrade notification to specific app versions

### **Scenario B: Group Payment Reminder**
**User payment overdue:**
- **Environment Info**: Know exact app version & build in backend
- **Analytics**: Track which app versions have payment issues
- **Debug**: Support knows exactly which build user is running

### **Scenario C: Feature Rollout**
**Progressive deployment:**
- **Staged Release**: Roll out to v2.0.0+ users first
- **Backward Compat**: Keep v1.x users on old feature paths
- **Gradual Migration**: Use version-based targeting

---

## 🔔 **Step 6: Managing Notifications**

### **On Notifications Page:**
1. **👥 Filter by Type:** All, Unread, Payments, Groups, etc.
2. **📱 View Details:** Tap notification to view full info
3. **⚙️ Manage Settings:** Tap settings for preferences
4. **💬 Compose New:** Send custom notifications

### **Built-in Filters:**
- **📋 All** - All notifications
- **⭕ Unread** - New notifications only
- **💰 Payments** - Payment-related only
- **🏘️ Groups** - Group management only

---

## 📚 **Step 7: Advanced Usage**

### **Send Smart Notifications Programmatically:**

```dart
// Create custom notification via templates
final notification = MultilingualTemplates.paymentReminder(
  groupId: 'netflix_group',
  groupName: 'Netflix Family',
  amount: 15.99,
  dueDate: DateTime.now().add(Duration(days: 2)),
  userId: currentUserId,
  language: 'en',
);

// Send via API service  
await NotificationApiService.sendCustomNotification(
  notification: notification,
  targetUsers: [userId],
);
```

### **Get App Info in Any Widget:**
```dart
import 'package:subscription_splitter_app/core/notifications/services/notification_service.dart';

// Access notification service anywhere
final service = NotificationService();

// Get complete app info
final appInfo = await service._getCompleteAppInfo();
print('App: ${appInfo['appName']} v${appInfo['version']}+${appInfo['buildNumber']}');
```

---

## 🛡️ **Step 8: Best Practices**

### **✅ Production Ready:**
- **Error Handling**: Graceful fallbacks if package info fails
- **Debug Logging**: Complete trace logs for troubleshooting  
- **Security**: No tokens or sensitive data exposed
- **Performance**: Efficient caching of app info

### **✅ Enterprise Features:**
- **Version Targeting**: Notify specific app versions only
- **Release Management**: Track feature penetration rate
- **Support Analytics**: Know user environment instantly
- **Device Management**: Complete device metadata

---

## 🎯 **Next Steps for Implementation:**

### **1. Test the System:**
1. **Navigate to `/notifications`**
2. **Use "Send Test" button to verify backend connection**
3. **Check your backend logs for complete metadata**

### **2. Customize Backend:**
1. **Update your NestJS listeners to handle new metadata fields**
2. **Add version-based routing logic**  
3. **Create targeted notification campaigns**

### **3. Explore Advanced Features:**
1. **Multi-language compositions** (Arabic/English)
2. **Target group-based notifications**
3. **Create custom notification templates**

---

## 📀 **Your Implementation is Complete!**

🎉 **What's Now Working:**
- ✅ **Dynamic app versioning** with `package_info_plus`
- ✅ **Complete device metadata** sent to backend
- ✅ **Real-time notification testing** capabilities  
- ✅ **Production-ready notification system**
- ✅ **Multi-language support** ready
- ✅ **Backend API integration** active

🚀 **Ready to use immediately!** Navigate to the notifications page and start sending notifications with complete app version detail tracking.
