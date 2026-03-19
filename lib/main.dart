import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise local storage
  await GetStorage.init();

  // Initialize Supabase properly in main.dart
  await Supabase.initialize(
    url: 'https://xpjhlskvkyqbfgetbrnn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhwamhsc2t2a3lxYmZnZXRicm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NDcxMTIsImV4cCI6MjA4OTQyMzExMn0.Ne5KZvaeLKzD_Lsg6l6QMbQCCOpP5PUOAUetbf1_66M',
  );

  runApp(const SquadBizzApp());
}

class SquadBizzApp extends StatelessWidget {
  const SquadBizzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
