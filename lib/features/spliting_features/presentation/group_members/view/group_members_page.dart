import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_members/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_members/widgets/group_members_body.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/contact_invitation/contact_invitation.dart';

/// {@template group_members_page}
/// A description for GroupMembersPage
/// {@endtemplate}
class GroupMembersPage extends StatelessWidget {
  /// {@macro group_members_page}
  const GroupMembersPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              GroupMembersBloc(groupId: groupId)..add(const LoadGroupMembers()),
      child: const GroupMembersView(),
    );
  }
}

/// {@template group_members_view}
/// Displays the Body of GroupMembersView
/// {@endtemplate}
class GroupMembersView extends StatelessWidget {
  /// {@macro group_members_view}
  const GroupMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupMembersBloc, GroupMembersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr.groupMembers),
            actions: [
              if (state.isSaving || state.isInviting || state.isRemoving)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ContactInvitationPage(
                              groupId: context.read<GroupMembersBloc>().groupId,
                              groupName:
                                  null, // Could get from state if available
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  tooltip: 'Invite from Contacts',
                ),
            ],
          ),
          body: const GroupMembersBody(),
        );
      },
    );
  }
}
