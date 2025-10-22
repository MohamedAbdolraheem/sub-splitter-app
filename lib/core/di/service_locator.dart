import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/core/notifications/services/notification_service.dart';
import 'package:subscription_splitter_app/core/notifications/services/notification_api_service.dart';
import 'package:subscription_splitter_app/core/localization/language_service.dart';
import 'package:subscription_splitter_app/core/contacts/services/contact_service.dart';
import 'package:subscription_splitter_app/core/contacts/services/contact_api_service.dart';
import 'package:subscription_splitter_app/core/contacts/repositories/contact_repository_impl.dart';
import 'package:subscription_splitter_app/core/contacts/repositories/contact_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/repositories/dashboard_repository_impl.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/repositories/groups_repository_impl.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/repositories/invites_repository_impl.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/repositories/payments_repository_impl.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/repositories/services_repository_impl.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/dashboard_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/invites_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/payments_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/services_repository.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/notifications_repository_impl.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/notifications_repository.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/invitation_repository.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/invitation_repository_impl.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/auth_repository.dart';
import 'package:subscription_splitter_app/features/user_features/data/repositories/auth_repositoy_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core services
  late final ApiService _apiService = ApiService();
  late final NotificationService _notificationService = NotificationService();
  late final NotificationApiService _notificationApiService =
      NotificationApiService(apiService: _apiService);
  late final LanguageService _languageService = LanguageService.instance;
  late final ContactService _contactService = ContactService.instance;
  late final ContactApiService _contactApiService = ContactApiService(
    apiService: _apiService,
  );

  // Repositories
  late final GroupsRepository _groupsRepository = GroupsRepositoryImpl(
    apiService: _apiService,
  );

  late final InvitesRepository _invitesRepository = InvitesRepositoryImpl(
    apiService: _apiService,
  );

  late final PaymentsRepository _paymentsRepository = PaymentsRepositoryImpl(
    apiService: _apiService,
  );

  late final ServicesRepository _servicesRepository = ServicesRepositoryImpl(
    apiService: _apiService,
  );

  late final DashboardRepository _dashboardRepository = DashboardRepositoryImpl(
    apiService: _apiService,
  );

  late final NotificationsRepository _notificationsRepository =
      NotificationsRepositoryImpl(
        notificationService: _notificationService,
        apiService: _notificationApiService,
      );

  late final ContactRepository _contactRepository = ContactRepositoryImpl(
    contactService: _contactService,
    apiService: _contactApiService,
  );

  late final InvitationRepository _invitationRepository =
      InvitationRepositoryImpl(
        notificationApiService: _notificationApiService,
        contactApiService: _contactApiService,
      );

  late final AuthRepository _authRepository = AuthRepositoryImpl(
    supabase: Supabase.instance.client,
  );

  late final NotificationsBloc _notificationsBloc = NotificationsBloc();

  // Getters
  ApiService get apiService => _apiService;
  LanguageService get languageService => _languageService;
  GroupsRepository get groupsRepository => _groupsRepository;
  InvitesRepository get invitesRepository => _invitesRepository;
  PaymentsRepository get paymentsRepository => _paymentsRepository;
  ServicesRepository get servicesRepository => _servicesRepository;
  DashboardRepository get dashboardRepository => _dashboardRepository;
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;
  ContactRepository get contactRepository => _contactRepository;
  InvitationRepository get invitationRepository => _invitationRepository;
  AuthRepository get authRepository => _authRepository;
  NotificationsBloc get notificationsBloc => _notificationsBloc;
}
