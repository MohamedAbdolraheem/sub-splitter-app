# 🔔 Backend Notification API Implementation

You're absolutely correct! The notification logic should be handled in your NestJS backend, not just in the Flutter app. Here's what you need to implement:

## 📋 Required Backend API Endpoints

### 1. **Send Notification to Single User**
```typescript
POST /api/notifications/send
```

### 2. **Send Notification to Multiple Users** 
```typescript
POST /api/notifications/send-bulk
```

### 3. **Send Notification to Group**
```typescript
POST /api/notifications/send-to-group
```

### 4. **Get User Notifications**
```typescript
GET /api/notifications
```

### 5. **Mark Notification as Read**
```typescript
PATCH /api/notifications/:id/read
```

### 6. **Delete Notification**
```typescript
DELETE /api/notifications/:id
```

### 7. **Update Notification Preferences**
```typescript
PATCH /api/notifications/preferences
```

## 🏗️ Implementation Steps

### Step 1: Install Required Dependencies
```bash
npm install firebase-admin
npm install @nestjs/firebase
```

### Step 2: Set up Firebase Admin
```typescript
// src/config/firebase.config.ts
import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';
import * as serviceAccount from '../path/to/serviceAccountKey.json';

@Injectable()
export class FirebaseConfig {
  private admin: admin.app.App;

  constructor() {
    this.admin = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: 'your-database-url'
    });
  }

  getApp() {
    return this.admin;
  }
}
```

### Step 3: Create Notification Controller
```typescript
// src/modules/notifications/notification.controller.ts
import { Controller, Post, Get, Patch, Delete, Body, Param, Query } from '@nestjs/common';

@Controller('notifications')
export class NotificationController {
  constructor(private notificationService: NotificationService) {}

  @Post('send')
  async sendNotification(@Body() notificationData: any) {
    return await this.notificationService.sendSingleNotification(notificationData);
  }

  @Post('send-bulk')
  async sendBulkNotification(@Body() notificationData: any) {
    return await this.notificationService.sendBulkNotification(notificationData);
  }

  @Post('send-to-group')
  async sendToGroup(@Body() notificationData: any) {
    return await this.notificationService.sendToGroup(notificationData);
  }

  @Get()
  async getUserNotifications(@Query() query: any) {
    return await this.notificationService.getUserNotifications(query);
  }

  @Patch(':id/read')
  async markAsRead(@Param('id') id: string) {
    return await this.notificationService.markAsRead(id);
  }

  @Delete(':id')
  async deleteNotification(@Param('id') id: string) {
    return await this.notificationService.deleteNotification(id);
  }

  @Patch('preferences')
  async updatePreferences(@Body() preferences: any) {
    return await this.notificationService.updatePreferences(preferences);
  }
}
```

### Step 4: Create Notification Service
```typescript
// src/modules/notifications/notification.service.ts
import { Injectable } from '@nestjs/common';
import { FirebaseConfig } from 'src/config/firebase.config';

@Injectable()
export class NotificationService {
  constructor(
    private firebaseConfig: FirebaseConfig,
    // Add your database service injection
  ) {}

  async sendSingleNotification(data: NotificationSendDTO) {
    const { userId, title, body, data: payload, language, type, groupId } = data;
    
    try {
      // 1. Save to database
      const notification = await this.saveToDatabase({
        userId,
        title,
        body,
        customText: data.customText,
        language,
        type,
        groupId,
        data: payload,
      });

      // 2. Get user's FCM tokens
      const fcmTokens = await this.getUserFCMTokens(userId);

      // 3. Send push notifications
      if (fcmTokens.length > 0) {
        await this.sendFCMNotification({
          tokens: fcmTokens,
          title,
          body,
          data: payload,
        });
      }

      return notification;
    } catch (error) {
      throw new Error(`Failed to send notification: ${error.message}`);
    }
  }

  async sendBulkNotification(data: BulkNotificationDTO) {
    const { userIds, title, body, data: payload, language, type, groupId } = data;
    
    // For each user, send individually
    const results = await Promise.allSettled(
      userIds.map(userId => 
        this.sendSingleNotification({
          userId,
          title,
          body,
          data: payload,
          customText: data.customText,
          language,
          type,
          groupId,
        })
      )
    );

    return results;
  }

  async sendToGroup(data: GroupNotificationDTO) {
    const { groupId, title, body, data: payload, language, type } = data;
    
    // 1. Get all group members
    const groupMembers = await this.getGroupMembers(groupId);
    
    // 2. Send to all members
    return await this.sendBulkNotification({
      userIds: groupMembers.map(member => member.id),
      title,
      body,
      data: payload,
      customText: data.customText,
      language,
      type,
      groupId,
    });
  }

  private async sendFCMNotification({ tokens, title, body, data }) {
    const messaging = this.firebaseConfig.getApp().messaging();
    
    const message = {
      notification: { title, body },
      data: data || {},
      tokens,
    };

    await messaging.sendMulticast(message);
  }

  private async saveToDatabase(notificationData) {
    // Implement your database save logic
    // Use your preferred database (MongoDB, PostgreSQL, etc.)
    return {
      id: 'generated-id',
      ...notificationData,
      timestamp: new Date(),
      isRead: false,
    };
  }

  private async getUserFCMTokens(userId) {
    // Get users FCM tokens from your database
    // Return array of tokens
    return [];
  }

  private async getGroupMembers(groupId) {
    // Get group members from your database
    return [];
  }
}
```

## 🔧 Data Transfer Objects (DTOs)

```typescript
// src/modules/notifications/dto/notification.dto.ts
export class NotificationSendDTO {
  userId: string;
  title: string;
  body: string;
  customText?: string;
  language?: string;
  type: string;
  groupId?: string;
  data?: Record<string, any>;
}

export class BulkNotificationDTO {
  userIds: string[];
  title: string;
  body: string;
  customText?: string;
  language?: string;
  type: string;
  groupId?: string;
  data?: Record<string, any>;
}

export class GroupNotificationDTO {
  groupId: string;
  title: string;
  body: string;
  customText?: string;
  language?: string;
  type: string;
  data?: Record<string, any>;
}
```

## 🔥 Flutter Integration

Once your backend is ready, update the Flutter app:

```typescript
// In custom_notification_composer.dart
Future<void> _sendNotificationViaAPI({
  required String title,
  required String body,
  required String customText,
  required String language,
  required NotificationType type,
  String? groupId,
  String? userId,
}) async {
  final apiService = NotificationApiService(
    apiService: ServiceLocator().apiService,
  );

  if (groupId != null) {
    await apiService.sendNotificationToGroup(
      groupId: groupId,
      title: title,
      body: body,
      customText: customText,
      language: language,
      type: type,
    );
  } else if (userId != null) {
    await apiService.sendNotificationToUser(
      userId: userId,
      title: title,
      body: body,
      customText: customText,
      language: language,
      type: type,
      groupId: groupId,
    );
  }
}
```

## 🔒 Security & Best Practices

1. **Authentication**: Verify user authentication
2. **Authorization**: Check if user can send to target
3. **Rate Limiting**: Implement rate limiting to prevent spam
4. **Validation**: Validate all input data
5. **Error Handling**: Proper error handling for FCM failures
6. **Logging**: Log all notification activities

## 🚀 Next Steps

1. Implement the NestJS backend endpoints
2. Set up Firebase Admin SDK
3. Connect your database
4. Test the endpoints
5. Update Flutter app API calls
6. Test end-to-end flow

This backend implementation will handle the heavy lifting and security, while your Flutter app just sends the data!
