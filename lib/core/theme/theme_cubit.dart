import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../utils/app_logger.dart';

/// Theme mode states.
enum AppThemeMode { light, dark }

/// Cubit that manages the app's theme preference (light/dark).
///
/// Uses HydratedCubit for automatic persistence — no SharedPreferences needed.
class ThemeCubit extends HydratedCubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.light);

  /// Toggle between light and dark.
  void toggleTheme() {
    final next = state == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    AppLogger.i('ThemeCubit → switched to ${next.name}');
    emit(next);
  }

  /// Set a specific theme mode.
  void setTheme(AppThemeMode mode) {
    AppLogger.i('ThemeCubit → set to ${mode.name}');
    emit(mode);
  }

  @override
  AppThemeMode? fromJson(Map<String, dynamic> json) {
    final value = json['theme'] as String?;
    return value == 'dark' ? AppThemeMode.dark : AppThemeMode.light;
  }

  @override
  Map<String, dynamic>? toJson(AppThemeMode state) {
    return {'theme': state.name};
  }
}
