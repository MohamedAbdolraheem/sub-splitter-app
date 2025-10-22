import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_settings/bloc/bloc.dart';

/// {@template group_settings_body}
/// Body of the GroupSettingsPage.
///
/// Add what it does
/// {@endtemplate}
class GroupSettingsBody extends StatefulWidget {
  /// {@macro group_settings_body}
  const GroupSettingsBody({super.key});

  @override
  State<GroupSettingsBody> createState() => _GroupSettingsBodyState();
}

class _GroupSettingsBodyState extends State<GroupSettingsBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _groupNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _totalCostController;
  late TextEditingController _maxMembersController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _totalCostController = TextEditingController();
    _maxMembersController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    _totalCostController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupSettingsBloc, GroupSettingsState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }

        if (state.isSaving == false && state.error == null) {
          // Check if this was a successful save
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr.save),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        // Update controllers when state changes
        if (state.groupName != _groupNameController.text) {
          _groupNameController.text = state.groupName;
        }
        if (state.description != _descriptionController.text) {
          _descriptionController.text = state.description;
        }
        if (state.totalCost.toString() != _totalCostController.text) {
          _totalCostController.text = state.totalCost.toString();
        }
        if (state.maxMembers.toString() != _maxMembersController.text) {
          _maxMembersController.text = state.maxMembers.toString();
        }

        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoCard(context, state),
                    const SizedBox(height: 16),
                    _buildBillingCard(context, state),
                    const SizedBox(height: 16),
                    _buildPrivacyCard(context, state),
                    const SizedBox(height: 16),
                    _buildAdvancedCard(context, state),
                    const SizedBox(height: 24),
                    _buildDangerZoneCard(context, state),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, GroupSettingsState state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.tr.groupInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: context.tr.groupName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr.required;
                }
                return null;
              },
              onChanged: (value) {
                context.read<GroupSettingsBloc>().add(GroupNameChanged(value));
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter group description...',
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              maxLines: 3,
              onChanged: (value) {
                context.read<GroupSettingsBloc>().add(
                  DescriptionChanged(value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingCard(BuildContext context, GroupSettingsState state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.payment,
                    color: Colors.green[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Billing Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _totalCostController,
              decoration: InputDecoration(
                labelText: context.tr.totalCost,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.attach_money),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr.required;
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                final cost = double.tryParse(value);
                if (cost != null) {
                  context.read<GroupSettingsBloc>().add(TotalCostChanged(cost));
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              context.tr.billingCycle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Monthly'),
                    selected: state.billingCycle == 'monthly',
                    onSelected: (selected) {
                      if (selected) {
                        context.read<GroupSettingsBloc>().add(
                          const BillingCycleChanged('monthly'),
                        );
                      }
                    },
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green[700],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Yearly'),
                    selected: state.billingCycle == 'yearly',
                    onSelected: (selected) {
                      if (selected) {
                        context.read<GroupSettingsBloc>().add(
                          const BillingCycleChanged('yearly'),
                        );
                      }
                    },
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context, GroupSettingsState state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.purple[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Privacy & Access',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Public Group'),
              subtitle: const Text('Anyone can find and join this group'),
              value: state.isPublic,
              onChanged: (value) {
                context.read<GroupSettingsBloc>().add(IsPublicChanged(value));
              },
              activeColor: Colors.purple[600],
            ),
            SwitchListTile(
              title: const Text('Allow Invites'),
              subtitle: const Text('Members can invite others to join'),
              value: state.allowInvites,
              onChanged: (value) {
                context.read<GroupSettingsBloc>().add(
                  AllowInvitesChanged(value),
                );
              },
              activeColor: Colors.purple[600],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxMembersController,
              decoration: InputDecoration(
                labelText: 'Maximum Members',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: 'Set the maximum number of members allowed',
                prefixIcon: const Icon(Icons.people_outline),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr.required;
                }
                final members = int.tryParse(value);
                if (members == null || members < 2) {
                  return 'Must be at least 2 members';
                }
                return null;
              },
              onChanged: (value) {
                final members = int.tryParse(value);
                if (members != null) {
                  context.read<GroupSettingsBloc>().add(
                    MaxMembersChanged(members),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCard(BuildContext context, GroupSettingsState state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.orange[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Advanced Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Auto Split'),
              subtitle: const Text(
                'Automatically split costs equally among members',
              ),
              value: state.autoSplit,
              onChanged: (value) {
                context.read<GroupSettingsBloc>().add(AutoSplitChanged(value));
              },
              activeColor: Colors.orange[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZoneCard(BuildContext context, GroupSettingsState state) {
    return Card(
      elevation: 2,
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.warning_outlined,
                    color: Colors.red[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Danger Zone',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Once you delete a group, there is no going back. Please be certain.',
              style: TextStyle(color: Colors.red[600], fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    state.isSaving
                        ? null
                        : () {
                          _showDeleteConfirmation(context);
                        },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Group'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[700],
                  side: BorderSide(color: Colors.red[700]!),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Group'),
            content: const Text(
              'Are you sure you want to delete this group? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.tr.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<GroupSettingsBloc>().add(const DeleteGroup());
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
