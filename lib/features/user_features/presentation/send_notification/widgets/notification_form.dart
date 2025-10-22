import 'package:flutter/material.dart';

import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/core/notifications/templates/multilingual_templates.dart';

/// {@template notification_form}
/// Form for composing notification content
/// {@endtemplate}
class NotificationForm extends StatelessWidget {
  /// {@macro notification_form}
  const NotificationForm({
    super.key,
    required this.titleController,
    required this.messageController,
    required this.selectedType,
    required this.selectedLanguage,
    required this.onTypeChanged,
    required this.onLanguageChanged,
  });

  final TextEditingController titleController;
  final TextEditingController messageController;
  final NotificationType selectedType;
  final String selectedLanguage;
  final ValueChanged<NotificationType> onTypeChanged;
  final ValueChanged<String> onLanguageChanged;

  // Only notification types that users can compose (must match backend API types)
  static const List<NotificationType> _userComposableTypes = [
    NotificationType.adminMessage,
    NotificationType.groupInvite,
    NotificationType.paymentReminder,
    NotificationType.renewalReminder,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNotificationTypeCard(context),
        const SizedBox(height: 16),
        _buildLanguageCard(context),
        const SizedBox(height: 16),
        _buildTitleCard(context),
        const SizedBox(height: 16),
        _buildMessageCard(context),
        const SizedBox(height: 16),
        _buildPreviewCard(context),
      ],
    );
  }

  Widget _buildNotificationTypeCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'Notification Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NotificationType>(
              value:
                  _userComposableTypes.contains(selectedType)
                      ? selectedType
                      : NotificationType.adminMessage,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items:
                  _userComposableTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Text(type.icon),
                          const SizedBox(width: 8),
                          Text(type.displayName),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onTypeChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: Colors.green[600]),
                const SizedBox(width: 8),
                Text(
                  'Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items:
                  MultilingualTemplates.supportedLanguages.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(
                        MultilingualTemplates.getLanguageDisplayName(language),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onLanguageChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.title, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Notification Title',
                border: const OutlineInputBorder(),
                hintText: _getTitleHint(),
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              textDirection: MultilingualTemplates.getLanguageDirection(
                selectedLanguage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.message, color: Colors.purple[600]),
                const SizedBox(width: 8),
                Text(
                  'Message',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Notification Message',
                border: const OutlineInputBorder(),
                hintText: _getMessageHint(),
                prefixIcon: const Icon(Icons.message),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Message is required';
                }
                return null;
              },
              textDirection: MultilingualTemplates.getLanguageDirection(
                selectedLanguage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview, color: Colors.indigo[600]),
                const SizedBox(width: 8),
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(selectedType.icon),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          titleController.text.isEmpty
                              ? _getTitleHint()
                              : titleController.text,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textDirection:
                              MultilingualTemplates.getLanguageDirection(
                                selectedLanguage,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          MultilingualTemplates.getLanguageDisplayName(
                            selectedLanguage,
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.blue[700], fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    messageController.text.isEmpty
                        ? _getMessageHint()
                        : messageController.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textDirection: MultilingualTemplates.getLanguageDirection(
                      selectedLanguage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleHint() {
    switch (selectedLanguage) {
      case 'ar':
        return 'عنوان الإشعار';
      default:
        return 'Notification Title';
    }
  }

  String _getMessageHint() {
    switch (selectedLanguage) {
      case 'ar':
        return 'اكتب رسالة الإشعار هنا...';
      default:
        return 'Write your notification message here...';
    }
  }
}
