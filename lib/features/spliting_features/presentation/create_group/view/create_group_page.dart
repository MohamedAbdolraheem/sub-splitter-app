import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/create_group/bloc/bloc.dart';
import 'package:subscription_splitter_app/features/spliting_features/presentation/create_group/widgets/create_group_body.dart';

/// {@template create_group_page}
/// A description for CreateGroupPage
/// {@endtemplate}
class CreateGroupPage extends StatelessWidget {
  /// {@macro create_group_page}
  const CreateGroupPage({super.key});

  /// The static route for CreateGroupPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const CreateGroupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateGroupBloc()..add(const LoadServices()),
      child: const Scaffold(body: CreateGroupView()),
    );
  }
}

/// {@template create_group_view}
/// Displays the Body of CreateGroupView
/// {@endtemplate}
class CreateGroupView extends StatelessWidget {
  /// {@macro create_group_view}
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreateGroupBody();
  }
}
