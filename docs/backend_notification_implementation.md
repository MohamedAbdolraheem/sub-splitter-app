# 🚀 Backend Notification API Implementation

Based on your 8 API endpoints specification, here's exactly what you need to implement:

## 📋 Your API Endpoints

```
POST /notifications/send                    # Send to single user
POST /notifications/send-bulk              # Send to multiple users  
POST /notifications/send-to-group          # Send to all group members
GET  /notifications?userId=xxx             # Get user notifications
PATCH /notifications/:id/read              # Mark as read
DELETE /notifications/:id                  # Delete notification
PATCH /notifications/preferences           # Update preferences
GET  /notifications/preferences/:userId    # Get preferences
POST /notifications/device-token           # Register device token
```

## 🔧 1. NestJS Controller Implementation

```typescript
// src/modules/notifications/notification.controller.ts
import {
  Controller,
  Post,
  Get,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  HttpStatus,
  HttpException,
} from '@nestjs/common';
import { NotificationService } from './notification.service';
import { 
  SendNotificationDto,
  SendBulkNotificationDto,
  SendToGroupDto,
  NotificationPreferencesDto,
  DeviceTokenDto,
} from './dto/notification.dto';

@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post('send')
  async sendNotification(@Body() data: SendNotificationDto) {
    return await this.notificationService.sendSingleUser(data);
  }

  @Post('send-bulk')
  async sendBulkNotification(@Body() data: SendBulkNotificationDto) {
    return await this.notificationService.sendToMultipleUsers(data);
  }

  @Post('send-to-group')
  async sendToGroup(@Body() data: SendToGroupDto) {
    return await this.notificationService.sendToGroup(data);
  }

  @Get()
  async getUserNotifications(
    @Query('userId') userId: string,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 20,
    @Query('type') type?: string,
    @Query('read') read?: boolean,
  ) {
    return await this.notificationService.getUserNotifications({
      userId,
      page: Number(page),
      limit: Number(limit),
      type,
      read,
    });
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
  async updatePreferences(@Body() data: NotificationPreferencesDto) {
    return await this.notificationService.updatePreferences(data);
  }

  @Get('preferences/:userId')
  async getPreferences(@Param('userId') userId: string) {
    return await this.notificationService.getPreferences(userId);
  }

  @Post('device-token')
  async registerDeviceToken(@Body() data: DeviceTokenDto) {
    return await this.notificationService.registerDeviceToken(data);
  }
}
```

## 📊 2. DTOs for Data Validation

```typescript
// src/modules/notifications/dto/notification.dto.ts
import { IsString, IsOptional, IsArray, IsNumber, IsBoolean, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

export class SendNotificationDto {
  @IsString()
  userId: string;

  @IsString()
  title: string;

  @IsString()
  body: string;

  @IsOptional()
  @IsString()
  customText?: string;

  @IsOptional()
  @IsString()
  language: string = 'en';

  @IsString()
  type: string;

  @IsOptional()
  @IsString()
  groupId?: string;

  @IsOptional()
  data?: Record<string, any>;
}

export class SendBulkNotificationDto {
  @IsArray()
  @IsString({ each: true })
  userIds: string[];

  @IsString()
  title: string;

  @IsString()
  body: string;

  @IsOptional()
  @IsString()
  customText?: string;

  @IsOptional()
  @IsString()
  language: string = 'en';

  @IsString()
  type: string;

  @IsOptional()
  @IsString()
  groupId?: string;

  @IsOptional()
  data?: Record<string, any>;
}

export class SendToGroupDto {
  @IsString()
  groupId: string;

  @IsString()
  title: string;

  @IsString()
  body: string;

  @IsOptional()
  @IsString()
  customText?: string;

  @IsOptional()
  @IsString()
  language: string = 'en';

  @IsString()
  type: string;

  @IsOptional()
  data?: Record<string, any>;
}

export class NotificationPreferencesDto {
  @IsString()
  userId: string;

  @IsBoolean()
  enabled: boolean;

  @IsBoolean()
  pushNotifications: boolean;

  @IsBoolean()
  emailNotifications: boolean;

  @IsBoolean()
  smsNotifications: boolean;

  @IsBoolean()
  paymentReminders: boolean;

  @IsBoolean()
  paymentOverdue: boolean;

  @IsBoolean()
  paymentConfirmations: boolean;

  @IsBoolean()
  newMemberJoined: boolean;

  @IsBoolean()
  memberLeft: boolean;

  @IsBoolean()
  groupInvitations: boolean;

  @IsBoolean()
  upcomingRenewals: boolean;

  @IsBoolean()
  renewalSuccessful: boolean;

  @IsBoolean()
  renewalFailed: boolean;

  @IsBoolean()
  groupHealthAlerts: boolean;

  @IsBoolean()
  lowGroupActivity: boolean;

  @IsBoolean()
  groupMessages: boolean;

  @IsBoolean()
  memberMentions: boolean;

  @IsBoolean()
  savingsMilestones: boolean;

  @IsBoolean()
  groupMilestones: boolean;

  @IsBoolean()
  appUpdates: boolean;

  @IsBoolean()
  serviceOutages: boolean;

  @IsBoolean()
  quietHoursEnabled: boolean;

  @IsOptional()
  quietHoursStart?: { hour: number; minute: number };

  @IsOptional()
  quietHoursEnd?: { hour: number; minute: number };
}

export class DeviceTokenDto {
  @IsString()
  userId: string;

  @IsString()
  token: string;

  @IsOptional()
  @IsString()
  deviceType?: string;

  @IsOptional()
  @IsString()
  appVersion?: string;
}

export class NotificationQueryDto {
  @IsString()
  userId: string;

  @Type(() => Number)
  @Min(1)
  page: number = 1;

  @Type(() => Number)
  @Min(1)
  @Max(100)
  limit: number = 20;

  @IsOptional()
  @IsString()
  type?: string;

  @IsOptional()
  @Type(() => Boolean)
  read?: boolean;
}
```

## 🏗️ 3. Service Implementation

```typescript
// src/modules/notifications/notification.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
// import { FirebaseAdminService } from '../firebase-admin/firebase-admin.service';

export interface NotificationFilters {
  userId: string;
  page: number;
  limit: number;
  type?: string;
  read?: boolean;
}

@Injectable()
export class NotificationService {
  constructor(
    // @InjectRepository(Notification)
    // private notificationRepo: Repository<Notification>,
    // 
    // @InjectRepository(NotificationPreferences)
    // private preferencesRepo: Repository<NotificationPreferences>,
    // 
    // @InjectRepository(DeviceToken)
    // private deviceTokenRepo: Repository<DeviceToken>,
    // 
    // @InjectRepository(GroupMember)
    // private groupMemberRepo: Repository<GroupMember>,

    // private firebaseAdminService: FirebaseAdminService,
  ) {}

  async sendSingleUser(data: SendNotificationDto) {
    try {
      // 1. Save to database
      const notification = await this.saveNotification({
        userIds: [data.userId],
        title: data.title,
        body: data.body,
        customText: data.customText,
        language: data.language,
        type: data.type,
        groupId: data.groupId,
        data: data.data,
        isRead: false,
        timestamp: new Date(),
      });

      // 2. Send push notification
      await this.sendPushNotification(data.userId, {
        title: data.title,
        body: data.body,
        data: data.data || {},
        notificationId: notification.id,
      });

      return {
        success: true,
        message: 'Notification sent successfully',
        data: notification,
      };
    } catch (error) {
      throw new HttpException(
        `Failed to send notification: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async sendToMultipleUsers(data: SendBulkNotificationDto) {
    try {
      // Save for each user
      const notifications = await Promise.all(
        data.userIds.map(async (userId) => {
          return await this.saveNotification({
            userIds: [userId],
            title: data.title,
            body: data.body,
            customText: data.customText,
            language: data.language,
            type: data.type,
            groupId: data.groupId,
            data: data.data,
            isRead: false,
            timestamp: new Date(),
          });
        })
      );

      // Send bulk push notifications
      await this.sendBulkPushNotifications(data.userIds, {
        title: data.title,
        body: data.body,
        data: data.data || {},
      });

      return {
        success: true,
        message: 'Bulk notifications sent successfully',
        data: { count: notifications.length, notifications },
      };
    } catch (error) {
      throw new HttpException(
        `Failed to send bulk notifications: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async sendToGroup(data: SendToGroupDto) {
    try {
      // Get group members
      const groupMembers = await this.getGroupMembers(data.groupId);
      const userIds = groupMembers.map(member => member.userId);

      // Send to all members
      return await this.sendToMultipleUsers({
        userIds,
        title: data.title,
        body: data.body,
        customText: data.customText,
        language: data.language,
        type: data.type,
        data: data.data,
      });
    } catch (error) {
      throw new HttpException(
        `Failed to send group notification: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async getUserNotifications(filters: NotificationFilters) {
    try {
      const skip = (filters.page - 1) * filters.limit;
      const take = filters.limit;

      // Build query
      const queryBuilder = this.notificationRepo
        .createQueryBuilder('notification')
        .where('notification.userIds @> :userId', { userId: `["${filters.userId}"]` })
        .skip(skip)
        .take(take)
        .orderBy('notification.timestamp', 'DESC');

      // Apply filters
      if (filters.type) {
        queryBuilder.andWhere('notification.type = :type', { type: filters.type });
      }

      if (filters.read !== undefined) {
        queryBuilder.andWhere('notification.isRead = :read', { read: filters.read });
      }

      const [notifications, total] = await queryBuilder.getManyAndCount();

      return {
        success: true,
        data: {
          notifications,
          total,
          page: filters.page,
          limit: filters.limit,
        },
      };
    } catch (error) {
      throw new HttpException(
        `Failed to get notifications: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async markAsRead(id: string) {
    try {
      await this.notificationRepo.update(id, { isRead: true });
      return { success: true, message: 'Notification marked as read' };
    } catch (error) {
      throw new HttpException(
        `Failed to mark notification as read: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async deleteNotification(id: string) {
    try {
      await this.notificationRepo.delete(id);
      return { success: true, message: 'Notification deleted successfully' };
    } catch (error) {
      throw new HttpException(
        `Failed to delete notification: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async updatePreferences(data: NotificationPreferencesDto) {
    try {
      const preferences = await this.preferencesRepo.save(data);
      return { success: true, message: 'Preferences updated', data: preferences };
    } catch (error) {
      throw new HttpException(
        `Failed to update preferences: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async getPreferences(userId: string) {
    try {
      const preferences = await this.preferencesRepo.findOne({ 
        where: { userId } 
      });
      
      if (!preferences) {
        // Return default preferences
        return {
          success: true,
          data: this.getDefaultPreferences(userId),
        };
      }

      return { success: true, data: preferences };
    } catch (error) {
      throw new HttpException(
        `Failed to get preferences: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  async registerDeviceToken(data: DeviceTokenDto) {
    try {
      // Save or update device token
      await this.deviceTokenRepo.save({
        userId: data.userId,
        token: data.token,
        deviceType: data.deviceType || 'mobile',
        appVersion: data.appVersion,
        updatedAt: new Date(),
      });

      return { success: true, message: 'Device token registered' };
    } catch (error) {
      throw new HttpException(
        `Failed to register device token: ${error.message}`,
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  private async saveNotification(data: any) {
    // Implement database save logic
    // return await this.notificationRepo.save(data);
  }

  private async sendPushNotification(userId: string, payload: any) {
    // Get user device tokens and send via Firebase
    // const tokens = await this.getUserTokens(userId);
    // await this.firebaseAdminService.send(tokens, payload);
  }

  private async sendBulkPushNotifications(userIds: string[], payload: any) {
    // Get all tokens and send
    // const allTokens = await this.getAllTokens(userIds);
    // await this.firebaseAdminService.sendMulticast(allTokens, payload);
  }

  private async getGroupMembers(groupId: string) {
    // Get group members from database
    // return await this.groupMemberRepo.find({ where: { groupId } });
  }

  private getDefaultPreferences(userId: string) {
    return {
      userId,
      enabled: true,
      pushNotifications: true,
      emailNotifications: false,
      smsNotifications: false,
      paymentReminders: true,
      paymentOverdue: true,
      paymentConfirmations: true,
      newMemberJoined: true,
      memberLeft: true,
      groupInvitations: true,
      upcomingRenewals: true,
      renewalSuccessful: true,
      renewalFailed: true,
      groupHealthAlerts: true,
      lowGroupActivity: false,
      groupMessages: true,
      memberMentions: true,
      savingsMilestones: true,
      groupMilestones: true,
      appUpdates: true,
      serviceOutages: true,
      quietHoursEnabled: false,
      quietHoursStart: { hour: 22, minute: 0 },
      quietHoursEnd: { hour: 8, minute: 0 },
    };
  }
}
```

## 🔧 4. Database Entities (Example for TypeORM + PostgreSQL)

```typescript
// src/modules/notifications/entities/notification.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('simple-array')
  userIds: string[];

  @Column()
  title: string;

  @Column()
  body: string;

  @Column({ nullable: true })
  customText?: string;

  @Column({ default: 'en' })
  language: string;

  @Column()
  type: string;

  @Column({ nullable: true })
  groupId?: string;

  @Column('jsonb', { nullable: true })
  data?: Record<string, any>;

  @Column({ default: false })
  isRead: boolean;

  @CreateDateColumn()
  timestamp: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

@Entity('notification_preferences')
export class NotificationPreferences {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  userId: string;

  @Column({ default: true })
  enabled: boolean;

  @Column({ default: true })
  pushNotifications: boolean;

  @Column({ default: false })
  emailNotifications: boolean;

  @Column({ default: false })
  smsNotifications: boolean;

  // ... add all preference fields

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

@Entity('device_tokens')
export class DeviceToken {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column()
  token: string;

  @Column({ default: 'mobile' })
  deviceType: string;

  @Column({ nullable: true })
  appVersion?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

## 🔥 5. Module Setup

```typescript
// src/modules/notifications/notification.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationController } from './notification.controller';
import { NotificationService } from './notification.service';
import { Notification } from './entities/notification.entity';
import { NotificationPreferences } from './entities/notification-preferences.entity';
import { DeviceToken } from './entities/device-token.entity';
// import { FirebaseAdminModule } from '../firebase-admin/firebase-admin.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Notification,
      NotificationPreferences,
      DeviceToken,
    ]),
    // FirebaseAdminModule,
  ],
  controllers: [NotificationController],
  providers: [NotificationService],
  exports: [NotificationService],
})
export class NotificationModule {}
```

## ✅ Summary

Your Flutter app is ready with the `NotificationApiService`, and you just need to implement these 8 backend endpoints in NestJS. Once both are connected:

1. **Flutter app calls your backend API**
2. **Backend validates, saves to database**
3. **Backend sends push notifications via FCM**
4. **Users receive notifications on their devices**

The implementation depends on your specific database (PostgreSQL, MongoDB, etc.) and authentication system!
