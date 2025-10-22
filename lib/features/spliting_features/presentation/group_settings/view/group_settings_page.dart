import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_settings/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_settings/widgets/group_settings_body.dart';

/// {@template group_settings_page}
/// A description for GroupSettingsPage
/// {@endtemplate}
class GroupSettingsPage extends StatelessWidget {
  /// {@macro group_settings_page}
  const GroupSettingsPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              GroupSettingsBloc(groupId: groupId)
                ..add(const LoadGroupSettings()),
      child: const GroupSettingsView(),
    );
  }
}

/// {@template group_settings_view}
/// Displays the Body of GroupSettingsView
/// {@endtemplate}
class GroupSettingsView extends StatelessWidget {
  /// {@macro group_settings_view}
  const GroupSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupSettingsBloc, GroupSettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr.groupSettings),
            actions: [
              if (state.isSaving)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    // Save functionality will be handled in the body
                    context.read<GroupSettingsBloc>().add(
                      const SaveGroupSettings(),
                    );
                  },
                  child: Text(context.tr.save),
                ),
            ],
          ),
          body: const GroupSettingsBody(),
        );
      },
    );
  }
}
