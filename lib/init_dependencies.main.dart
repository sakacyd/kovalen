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
  _initMatchingPreferences();
  _initAdmin();
  _initGroupSchedule();
  _initGroupActivity();
  _initRating();

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
    ..registerFactory(() => GetHomeStats(serviceLocator()))
    ..registerFactory(() => WatchHomeData(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => HomeBloc(
        getCurrentUser: serviceLocator<GetCurrentUser<HomeRepository>>(),
        watchHomeData: serviceLocator(),
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
    ..registerFactory(() => GetUserInterests(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => ProfileBloc(
        appUserCubit: serviceLocator(),
        getCurrentUser: serviceLocator<GetCurrentUser<ProfileRepository>>(),
        getUserInterests: serviceLocator(),
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
      () => GetAvailableInterests<ProfileSettingsRepository>(serviceLocator()),
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
        getAvailableInterests:
            serviceLocator<GetAvailableInterests<ProfileSettingsRepository>>(),
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
    ..registerFactory(() => WatchNewMatches(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => MatchmakingBloc(
        getPotentialMatches: serviceLocator(),
        swipeUser: serviceLocator(),
        watchNewMatches: serviceLocator(),
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
    ..registerFactory(() => WatchChatRooms(serviceLocator()))
    // bloc
    ..registerLazySingleton(() => MessagesBloc(watchChatRooms: serviceLocator()));
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
    ..registerFactory(
      () => GetAvailableInterests<OnboardingRepository>(serviceLocator()),
    )
    // bloc
    ..registerLazySingleton(
      () => OnboardingBloc(
        submitOnboardingData: serviceLocator(),
        getUniversitiesData:
            serviceLocator<GetUniversitiesData<OnboardingRepository>>(),
        getStudyProgramsData:
            serviceLocator<GetStudyProgramsData<OnboardingRepository>>(),
        getAvailableInterests:
            serviceLocator<GetAvailableInterests<OnboardingRepository>>(),
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

void _initMatchingPreferences() {
  serviceLocator
    // datasource
    ..registerFactory<MatchingPreferencesRemoteDataSource>(
      () => MatchingPreferencesRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<MatchingPreferencesRepository>(
      () => MatchingPreferencesRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // usecases
    ..registerFactory(() => GetMatchingPreferences(serviceLocator()))
    ..registerFactory(() => SaveMatchingPreferences(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => MatchingPreferencesBloc(
        getMatchingPreferences: serviceLocator(),
        saveMatchingPreferences: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initAdmin() {
  serviceLocator
    // datasource
    ..registerFactory<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<AdminRepository>(
      () => AdminRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetAllUsers(serviceLocator()))
    ..registerFactory(() => GetAllGroups(serviceLocator()))
    ..registerFactory(() => ChangeUserRole(serviceLocator()))
    ..registerFactory(() => DeleteUser(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => AdminBloc(
        getAllUsers: serviceLocator(),
        getAllGroups: serviceLocator(),
        changeUserRole: serviceLocator(),
        deleteUser: serviceLocator(),
      ),
    );
}

void _initGroupSchedule() {
  serviceLocator
    // datasource
    ..registerFactory<GroupScheduleRemoteDataSource>(
      () => GroupScheduleRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<GroupScheduleRepository>(
      () => GroupScheduleRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetActiveSchedule(serviceLocator()))
    ..registerFactory(() => CreateSchedule(serviceLocator()))
    ..registerFactory(() => CompleteSchedule(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => GroupScheduleBloc(
        getActiveSchedule: serviceLocator(),
        createSchedule: serviceLocator(),
        completeSchedule: serviceLocator(),
      ),
    );
}

void _initGroupActivity() {
  serviceLocator
    // datasource
    ..registerFactory<GroupActivityRemoteDataSource>(
      () => GroupActivityRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<GroupActivityRepository>(
      () => GroupActivityRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => CreateGroupActivity(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => GroupActivityBloc(
        createGroupActivity: serviceLocator(),
      ),
    );
}

void _initRating() {
  serviceLocator
    // datasource
    ..registerFactory<RatingRemoteDataSource>(
      () => RatingRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<RatingRepository>(
      () => RatingRepositoryImpl(serviceLocator()),
    )
    // usecases
    ..registerFactory(() => RateUser(serviceLocator()))
    ..registerFactory(() => GetRoomParticipants(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => RatingBloc(
        rateUser: serviceLocator(),
        getRoomParticipants: serviceLocator(),
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
