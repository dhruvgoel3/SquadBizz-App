import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'injection.dart';
import 'core/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Bloc caching (HydratedBloc) ──
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  // ── System UI style ──
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // ── Lock portrait mode ──
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Initialize Supabase ──
  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://xpjhlskvkyqbfgetbrnn.supabase.co',
    ),
    anonKey: const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhwamhsc2t2a3lxYmZnZXRicm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NDcxMTIsImV4cCI6MjA4OTQyMzExMn0.Ne5KZvaeLKzD_Lsg6l6QMbQCCOpP5PUOAUetbf1_66M',
    ),
  );
  AppLogger.i('✔ Supabase initialized');

  // ── Initialize all dependencies ──
  await initDependencies();
  AppLogger.i('✔ Dependencies injected');

  runApp(const SquadBizzApp());
}
