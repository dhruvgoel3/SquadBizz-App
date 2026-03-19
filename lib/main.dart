import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_pages.dart';
import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise local storage
  await GetStorage.init();

  // Initialise Supabase before the app starts
  await SupabaseService.init();

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
