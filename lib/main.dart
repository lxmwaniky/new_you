import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'core/app_state.dart';
import 'core/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();
  await setupDependencies();
  runApp(const NewYouApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class NewYouApp extends StatefulWidget {
  const NewYouApp({super.key});

  @override
  State<NewYouApp> createState() => _NewYouAppState();
}

class _NewYouAppState extends State<NewYouApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: MaterialApp.router(
        title: 'New You - Habit Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppStateProvider extends InheritedWidget {
  final AppState state;

  const AppStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) =>
      state != oldWidget.state;
}
