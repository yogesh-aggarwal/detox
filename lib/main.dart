import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:detox/core/firebase_options.dart';
import 'package:detox/core/logging.dart';
import 'package:detox/core/monitor.dart';
import 'package:detox/providers/usage.dart';
import 'package:detox/providers/user.dart';
import 'package:detox/widgets/screens/analysis/analysis.dart';
import 'package:detox/widgets/screens/auth/login.dart';
import 'package:detox/widgets/screens/settings/settings.dart';
import 'package:detox/widgets/screens/tracker/tracker.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void scheduleBackgroundTask() async {
  await AndroidAlarmManager.initialize();

  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.periodic(
    Duration(seconds: 10),
    0,
    monitor,
    exact: true,
    allowWhileIdle: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );

  logger.i("Background task scheduled");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  scheduleBackgroundTask();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UsageProvider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: "Detox",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          themeMode: ThemeMode.system,
          home: Detox(),
        );
      },
    );
  }
}

class Detox extends StatefulWidget {
  const Detox({super.key});

  @override
  State<Detox> createState() => _DetoxState();
}

class _DetoxState extends State<Detox> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<UserProvider>().initAuth(
      onUserAvailable: () {
        context
            .read<UsageProvider>()
            .listen(context.read<UserProvider>().user!.trackedAppPackages);
      },
    );

    context.read<UserProvider>().addListener(() {
      final user = context.read<UserProvider>().user;
      if (user == null) {
        setState(() {
          _selectedIndex = 0;
        });
        return;
      }
      context.read<UsageProvider>().listen(user.trackedAppPackages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Scaffold(
        body: SafeArea(child: LoginScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detox",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: (() {
        switch (_selectedIndex) {
          case 0:
            return const TrackerScreen();
          case 1:
            return const AnalysisScreen();
          case 2:
            return const SettingsScreen();
          default:
            return const Placeholder();
        }
      })(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Tracker',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics),
            icon: Icon(Icons.analytics_outlined),
            label: 'Analysis',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
