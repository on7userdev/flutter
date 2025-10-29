import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:beacon_bloom/theme.dart';
import 'package:beacon_bloom/screens/home_page.dart';
import 'package:beacon_bloom/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:beacon_bloom/firebase_options.dart';
// Ensures web plugins (e.g., Firebase web) are registered before use on web.
import 'web_plugins_stub.dart'
    if (dart.library.html) 'custom_web_plugin_registrant.dart' as web_plugins;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // On web, some environments require explicit plugin registration before
  // platform interfaces are available. This ensures Firebase web bindings
  // are ready before initializeApp is called.
  if (kIsWeb) {
    try {
      // Manually register web plugins (Firebase core + Firestore) if needed.
      web_plugins.ensureManualWebPluginRegistration();
    } catch (_) {
      // Safe to ignore: the registrant may already be invoked by bootstrap.
    }
  }
  // Initialize Firebase before loading app state.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppState.I.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppState.I.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Beacon Bloom',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: const HomePage(),
        );
      },
    );
  }
}
