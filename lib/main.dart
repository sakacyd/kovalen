import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kovalen/core/theme/theme.dart';
import 'package:kovalen/init_dependencies.dart';
import 'package:kovalen/main_page.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/bloc/auth_bloc.dart';
import 'package:kovalen/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id_ID';
  initializeDateFormatting('id_ID', '');

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        /* BlocProvider(create: (_) => serviceLocator<DashboardBloc>()),
        BlocProvider(create: (_) => serviceLocator<TodayBloc>()),
        BlocProvider(create: (_) => serviceLocator<HistoryBloc>()),
        BlocProvider(create: (_) => serviceLocator<ReportBloc>()),
        BlocProvider(create: (_) => serviceLocator<SubmitReportBloc>()),
        BlocProvider(create: (_) => BottomNavCubit()), */
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kovalen',
      theme: AppTheme.lightThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const MainPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
