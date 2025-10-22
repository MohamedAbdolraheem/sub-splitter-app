import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/groups/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/groups/widgets/groups_body.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';

/// {@template groups_page}
/// A description for GroupsPage
/// {@endtemplate}
class GroupsPage extends StatelessWidget {
  /// {@macro groups_page}
  const GroupsPage({super.key});

  /// The static route for GroupsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const GroupsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              GroupsBloc(groupsRepository: ServiceLocator().groupsRepository)
                ..add(const LoadGroups()),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Groups'),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<GroupsBloc>().add(const LoadGroups());
                    },
                    tooltip: 'Refresh Groups',
                  ),
                ],
              ),
              body: const GroupsView(),
            ),
      ),
    );
  }
}

/// {@template groups_view}
/// Displays the Body of GroupsView
/// {@endtemplate}
class GroupsView extends StatelessWidget {
  /// {@macro groups_view}
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupsBody();
  }
}
