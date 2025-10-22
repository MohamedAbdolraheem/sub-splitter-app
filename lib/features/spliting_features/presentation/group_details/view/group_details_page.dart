import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_details/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/group_details/widgets/group_details_body.dart';

/// {@template group_details_page}
/// A description for GroupDetailsPage
/// {@endtemplate}
class GroupDetailsPage extends StatelessWidget {
  /// {@macro group_details_page}
  const GroupDetailsPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GroupDetailsBloc(groupId: groupId);
        bloc.add(const LoadGroupDetails());
        return bloc;
      },
      child: const Scaffold(body: GroupDetailsView()),
    );
  }
}

/// {@template group_details_view}
/// Displays the Body of GroupDetailsView
/// {@endtemplate}
class GroupDetailsView extends StatelessWidget {
  /// {@macro group_details_view}
  const GroupDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupDetailsBody();
  }
}
