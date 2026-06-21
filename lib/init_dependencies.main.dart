part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env");

  _initAuth();

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
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignOut: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
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
}

void _initDashboard() {
  serviceLocator
    // datasource
    ..registerFactory<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<DashboardRepository>(
      () => DashboardRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // usecases
    ..registerFactory(() => GetNearestAssignment(serviceLocator()))
    ..registerFactory(() => GetCurrentUser(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => DashboardBloc(
        getNearestAssignment: serviceLocator(),
        getCurrentUser: serviceLocator(),
      ),
    );
}

void _initReport() {
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