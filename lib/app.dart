import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/constants/app_strings.dart';
import 'injection.dart';

/// Root widget of the SquadBizz app.
///
/// Wraps the app in ScreenUtilInit for responsive sizing,
/// and BlocProvider for theme switching.
class SquadBizzApp extends StatelessWidget {
  const SquadBizzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 viewport
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => sl<ThemeCubit>(),
          child: BlocBuilder<ThemeCubit, AppThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: AppStrings.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode == AppThemeMode.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                routerConfig: appRouter,
              );
            },
          ),
        );
      },
    );
  }
}
