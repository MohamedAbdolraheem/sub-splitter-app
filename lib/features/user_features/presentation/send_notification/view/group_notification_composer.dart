import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import '../bloc/send_notification_bloc.dart';
import '../widgets/notification_form.dart';
import '../widgets/user_selection.dart';

/// {@template group_notification_composer}
/// Modal for composing and sending notifications to group members
/// {@endtemplate}
class GroupNotificationComposer extends StatefulWidget {
  /// {@macro group_notification_composer}
  const GroupNotificationComposer({
    super.key,
    required this.groupId,
    this.groupName,
  });

  final String groupId;
  final String? groupName;

  @override
  State<GroupNotificationComposer> createState() =>
      _GroupNotificationComposerState();
}

class _GroupNotificationComposerState extends State<GroupNotificationComposer> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  NotificationType _selectedType = NotificationType.adminMessage;
  String _selectedLanguage = 'en';
  bool _sendToAll = false;

  @override
  void initState() {
    super.initState();
    // Load group members when modal opens
    context.read<SendNotificationBloc>().add(
      LoadGroupMembers(groupId: widget.groupId),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendNotificationBloc, SendNotificationState>(
      listener: (context, state) {
        if (state is SendNotificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Notifications sent successfully (${state.sentCount}/${state.totalCount})',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is SendNotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildHandle(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 16),
                          NotificationForm(
                            titleController: _titleController,
                            messageController: _messageController,
                            selectedType: _selectedType,
                            selectedLanguage: _selectedLanguage,
                            onTypeChanged:
                                (type) => setState(() => _selectedType = type),
                            onLanguageChanged:
                                (language) => setState(
                                  () => _selectedLanguage = language,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildSendOptions(),
                          const SizedBox(height: 16),
                          UserSelection(
                            sendToAll: _sendToAll,
                            onSendToAllChanged:
                                (value) => setState(() => _sendToAll = value),
                          ),
                          const SizedBox(height: 24),
                          _buildSendButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.send, color: Colors.blue[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Notification',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (widget.groupName != null)
                Text(
                  'to ${widget.groupName}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSendOptions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Text(
                  'Send To',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Send to all group members'),
              subtitle: const Text(
                'Send notification to everyone in the group',
              ),
              value: _sendToAll,
              onChanged: (value) {
                setState(() {
                  _sendToAll = value;
                  if (value) {
                    // Clear individual selections when sending to all
                    context.read<SendNotificationBloc>().add(const ClearForm());
                  }
                });
              },
              activeColor: Colors.blue[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return BlocBuilder<SendNotificationBloc, SendNotificationState>(
      builder: (context, state) {
        final isLoading = state is SendNotificationLoading;
        final isSending = state is SendNotificationLoaded && state.isSending;
        final canSend =
            !_sendToAll ||
            (state is SendNotificationLoaded && state.groupMembers.isNotEmpty);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                (isLoading || isSending || !canSend) ? null : _sendNotification,
            icon:
                isLoading || isSending
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.send),
            label: Text(
              isLoading
                  ? 'Loading...'
                  : isSending
                  ? 'Sending...'
                  : _sendToAll
                  ? 'Send to All Members'
                  : 'Send to Selected',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _sendNotification() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (_sendToAll) {
      context.read<SendNotificationBloc>().add(
        SendNotificationToAll(
          groupId: widget.groupId,
          title: title,
          message: message,
          type: _selectedType,
          language: _selectedLanguage,
        ),
      );
    } else {
      // Get selected users from current state
      final currentState = context.read<SendNotificationBloc>().state;
      if (currentState is SendNotificationLoaded) {
        context.read<SendNotificationBloc>().add(
          SendNotificationToUsers(
            userIds: currentState.selectedUserIds,
            title: title,
            message: message,
            type: _selectedType,
            groupId: widget.groupId,
            language: _selectedLanguage,
          ),
        );
      }
    }
  }
}
