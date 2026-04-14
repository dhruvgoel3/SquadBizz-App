import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_logger.dart';

/// Splash screen states.
enum SplashState { loading, authenticated, unauthenticated }

/// Controls the splash screen lifecycle.
///
/// Checks Supabase session after a brief delay, then emits
/// [authenticated] or [unauthenticated].
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.loading) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    AppLogger.i('SplashCubit → checking auth session...');
    await Future.delayed(AppConstants.splashDelay);

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      AppLogger.i('SplashCubit → authenticated (user: ${session.user.id})');
      emit(SplashState.authenticated);
    } else {
      AppLogger.i('SplashCubit → unauthenticated');
      emit(SplashState.unauthenticated);
    }
  }
}
