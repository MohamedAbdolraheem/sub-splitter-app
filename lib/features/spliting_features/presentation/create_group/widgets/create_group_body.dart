import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/core/router/screens.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/create_group/bloc/bloc.dart';

/// {@template create_group_body}
/// Body of the CreateGroupPage.
///
/// Add what it does
/// {@endtemplate}
class CreateGroupBody extends StatefulWidget {
  /// {@macro create_group_body}
  const CreateGroupBody({super.key});

  @override
  State<CreateGroupBody> createState() => _CreateGroupBodyState();
}

class _CreateGroupBodyState extends State<CreateGroupBody> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Service icons mapping
  final Map<String, IconData> _serviceIcons = {
    'netflix': Icons.movie,
    'spotify': Icons.music_note,
    'adobe': Icons.design_services,
    'microsoft': Icons.business,
    'disney': Icons.family_restroom,
    'youtube': Icons.play_circle,
    'amazon': Icons.shopping_cart,
    'apple': Icons.apple,
    'default': Icons.subscriptions,
  };

  final List<String> _billingCycles = ['monthly', 'yearly'];

  @override
  void dispose() {
    _groupNameController.dispose();
    _totalCostController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.createGroup),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) {
          if (state.status == CreateGroupStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.groupJoined),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            context.go(Screens.homeDashboard.path);
          } else if (state.status == CreateGroupStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? context.tr.unknownError),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(context, colorScheme),
                  const SizedBox(height: 24),

                  // Group Name Field
                  _buildGroupNameField(context, state),
                  const SizedBox(height: 16),

                  // Service Selection
                  _buildServiceSelection(context, state),
                  const SizedBox(height: 16),

                  // Total Cost Field
                  _buildTotalCostField(context, state),
                  const SizedBox(height: 16),

                  // Billing Cycle Selection
                  _buildBillingCycleSelection(context, state),
                  const SizedBox(height: 16),

                  // Description Field
                  _buildDescriptionField(context, state),
                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.group_add, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            context.tr.createNewGroup,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr.manageSubscriptions,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupNameField(BuildContext context, CreateGroupState state) {
    return TextFormField(
      controller: _groupNameController,
      decoration: InputDecoration(
        labelText: context.tr.groupName,
        hintText: context.tr.groupName,
        prefixIcon: const Icon(Icons.group),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.tr.required;
        }
        return null;
      },
      onChanged: (value) {
        context.read<CreateGroupBloc>().add(GroupNameChanged(value));
      },
    );
  }

  Widget _buildServiceSelection(BuildContext context, CreateGroupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.service,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              state.services.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : Column(
                    children:
                        state.services.map((service) {
                          final isSelected = state.serviceId == service.id;
                          final icon = _getServiceIcon(
                            service.name.toLowerCase(),
                          );
                          return ListTile(
                            leading: Icon(
                              icon,
                              color:
                                  isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                            ),
                            title: Text(service.name),
                            subtitle: Text(
                              service.description,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : null,
                            onTap: () {
                              context.read<CreateGroupBloc>().add(
                                ServiceChanged(service.id),
                              );
                            },
                            tileColor:
                                isSelected
                                    ? Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1)
                                    : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }).toList(),
                  ),
        ),
      ],
    );
  }

  IconData _getServiceIcon(String serviceName) {
    // Try to find a matching icon based on service name
    for (final entry in _serviceIcons.entries) {
      if (serviceName.contains(entry.key)) {
        return entry.value;
      }
    }
    return _serviceIcons['default']!;
  }

  Widget _buildTotalCostField(BuildContext context, CreateGroupState state) {
    return TextFormField(
      controller: _totalCostController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: context.tr.totalCost,
        hintText: context.tr.totalCost,
        prefixIcon: const Icon(Icons.attach_money),
        suffixText: '\$',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.tr.required;
        }
        final cost = double.tryParse(value);
        if (cost == null || cost <= 0) {
          return context.tr.required;
        }
        return null;
      },
      onChanged: (value) {
        final cost = double.tryParse(value);
        if (cost != null) {
          context.read<CreateGroupBloc>().add(TotalCostChanged(cost));
        }
      },
    );
  }

  Widget _buildBillingCycleSelection(
    BuildContext context,
    CreateGroupState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.billingCycle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children:
              _billingCycles.map((cycle) {
                final isSelected = state.billingCycle == cycle;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        cycle == 'monthly'
                            ? context.tr.monthly
                            : context.tr.yearly,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<CreateGroupBloc>().add(
                            BillingCycleChanged(cycle),
                          );
                        }
                      },
                      selectedColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context, CreateGroupState state) {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: context.tr.bio,
        hintText: context.tr.bio,
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      onChanged: (value) {
        context.read<CreateGroupBloc>().add(DescriptionChanged(value));
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, CreateGroupState state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                state.status == CreateGroupStatus.loading
                    ? null
                    : () {
                      context.read<CreateGroupBloc>().add(
                        const CreateGroupReset(),
                      );
                      context.go(Screens.homeDashboard.path);
                    },
            child: Text(context.tr.cancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed:
                state.status == CreateGroupStatus.loading || !state.isValid
                    ? null
                    : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<CreateGroupBloc>().add(
                          const CreateGroupSubmitted(),
                        );
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                state.status == CreateGroupStatus.loading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(context.tr.createGroup),
          ),
        ),
      ],
    );
  }
}
