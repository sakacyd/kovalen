part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env");

  _initAuth();
  _initHome();
  _initProfile();
  _initProfileSettings();
  _initMatchmaking();
  _initMessages();
  _initMessageRoom();
  _initOnboarding();

  if (AppSecrets.supabaseUrl == null || AppSecrets.supabaseKey == null) {
    throw Exception('Supabase credentials not found');
  }
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl!,
    anonKey: AppSecrets.supabaseKey!,
  );

  Hive.init((await getApplicationDocumentsDirectory()).path);
  serviceLocator.registerLazySingleton(() => Hive.box('assignments'));

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(() => BottomNavCubit());

  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    //datasource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    //usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => ChangePassword(serviceLocator()))
    ..registerFactory(() => UpdateUserLocation(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        changePassword: serviceLocator(),
        appUserCubit: serviceLocator(),
        updateUserLocation: serviceLocator(),
      ),
    );
}

void _initHome() {
  serviceLocator
    // datasource
    ..registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetCurrentUser<HomeRepository>(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => HomeBloc(
        getCurrentUser: serviceLocator<GetCurrentUser<HomeRepository>>(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    // datasource
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetCurrentUser<ProfileRepository>(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => ProfileBloc(
        appUserCubit: serviceLocator(),
        getCurrentUser: serviceLocator<GetCurrentUser<ProfileRepository>>(),
      ),
    );
}

void _initProfileSettings() {
  serviceLocator
    // datasource
    ..registerFactory<ProfileSettingsRemoteDataSource>(
      () => ProfileSettingsRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<ProfileSettingsRepository>(
      () => ProfileSettingsRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => UpdateUserProfile(serviceLocator()))
    ..registerFactory(
      () => GetUniversitiesData<ProfileSettingsRepository>(serviceLocator()),
    )
    ..registerFactory(
      () => GetStudyProgramsData<ProfileSettingsRepository>(serviceLocator()),
    )
    // bloc
    ..registerLazySingleton(
      () => ProfileSettingsBloc(
        appUserCubit: serviceLocator(),
        updateUserProfile: serviceLocator(),
        getUniversitiesData:
            serviceLocator<GetUniversitiesData<ProfileSettingsRepository>>(),
        getStudyProgramsData:
            serviceLocator<GetStudyProgramsData<ProfileSettingsRepository>>(),
        userSignOut: serviceLocator(),
      ),
    );
}

void _initMatchmaking() {
  serviceLocator
    // datasource
    ..registerFactory<MatchmakingRemoteDataSource>(
      () => MatchmakingRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<MatchmakingRepository>(
      () => MatchmakingRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetPotentialMatches(serviceLocator()))
    ..registerFactory(() => SwipeUser(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => MatchmakingBloc(
        getPotentialMatches: serviceLocator(),
        swipeUser: serviceLocator(),
      ),
    );
}

void _initMessages() {
  serviceLocator
    // datasource
    ..registerFactory<MessagesRemoteDataSource>(
      () => MessagesRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<MessagesRepository>(
      () => MessagesRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetChatRooms(serviceLocator()))
    ..registerFactory(() => GetMessages(serviceLocator()))
    ..registerFactory(() => SendMessageUseCase(serviceLocator()))
    // bloc
    ..registerLazySingleton(() => MessagesBloc(getChatRooms: serviceLocator()));
}

void _initOnboarding() {
  serviceLocator
    // datasource
    ..registerFactory<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<OnboardingRepository>(
      () => OnboardingRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => SubmitOnboardingData(serviceLocator()))
    ..registerFactory(
      () => GetUniversitiesData<OnboardingRepository>(serviceLocator()),
    )
    ..registerFactory(
      () => GetStudyProgramsData<OnboardingRepository>(serviceLocator()),
    )
    // bloc
    ..registerLazySingleton(
      () => OnboardingBloc(
        submitOnboardingData: serviceLocator(),
        getUniversitiesData:
            serviceLocator<GetUniversitiesData<OnboardingRepository>>(),
        getStudyProgramsData:
            serviceLocator<GetStudyProgramsData<OnboardingRepository>>(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initMessageRoom() {
  serviceLocator
    // datasource
    ..registerFactory<MessageRoomRemoteDataSource>(
      () => MessageRoomRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<MessageRoomRepository>(
      () => MessageRoomRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetMessageRoomMessages(serviceLocator()))
    ..registerFactory(() => SendMessageRoomMessage(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => MessageRoomBloc(
        getMessageRoomMessages: serviceLocator(),
        sendMessageRoomMessage: serviceLocator(),
      ),
    );
}

/* void _initAssignment() {
  serviceLocator
    // datasource
    ..registerFactory<AssignmentRemoteDataSource>(
      () => AssignmentRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<AssignmentLocalDataSource>(
      () => AssignmentLocalDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<AssignmentRepository>(
      () => AssignmentRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // usecases
    ..registerFactory(() => GetTodayAssignments(serviceLocator()))
    ..registerFactory(() => GetPreviousAssignments(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => TodayBloc(getTodayAssignments: serviceLocator()),
    )
    ..registerLazySingleton(
      () => HistoryBloc(getPreviousAssignments: serviceLocator()),
    );
} */

/* void _initReport() {
  serviceLocator
    // datasource
    ..registerFactory<ReportRemoteDataSource>(
      () => ReportRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<ReportRepository>(
      () => ReportRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => UpdateTechnicianArrivedAt(serviceLocator()))
    ..registerFactory(() => UpdateAssignmentStartedAt(serviceLocator()))
    ..registerFactory(() => UpdateAssignmentFinishedAt(serviceLocator()))
    ..registerFactory(() => UpdateAssignmentStatus(serviceLocator()))
    ..registerFactory(() => GetReportByAssignmentId(serviceLocator()))
    ..registerFactory(() => SubmitInstallationReport(serviceLocator()))
    ..registerFactory(() => UploadInspectionReport(serviceLocator()))
    ..registerFactory(() => UploadInspectionItem(serviceLocator()))
    ..registerFactory(() => UploadSurveyReport(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => ReportBloc(
        updateTechnicianArrivedAt: serviceLocator(),
        updateAssignmentStartedAt: serviceLocator(),
        updateAssignmentFinishedAt: serviceLocator(),
        updateAssignmentStatus: serviceLocator(),
        getReportByAssignmentId: serviceLocator(),
      ),
    )

    ..registerLazySingleton(
      () => SubmitReportBloc(
        submitInstallationReportForm: serviceLocator(),
        uploadInspectionReport: serviceLocator(),
        uploadInspectionItem: serviceLocator(),
        uploadSurveyReport: serviceLocator(),
      ),
    );
} */
