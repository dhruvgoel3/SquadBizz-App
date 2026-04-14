import 'package:get_it/get_it.dart';

import 'core/theme/theme_cubit.dart';

// ── Feature: Auth ──
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_with_email.dart';
import 'features/auth/domain/usecases/register_with_email.dart';
import 'features/auth/domain/usecases/send_otp.dart';
import 'features/auth/domain/usecases/verify_otp.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// ── Feature: Home / Rooms ──
import 'features/home/data/datasources/room_remote_datasource.dart';
import 'features/home/data/repositories/room_repository_impl.dart';
import 'features/home/domain/repositories/room_repository.dart';
import 'features/home/domain/usecases/get_user_rooms.dart';
import 'features/home/domain/usecases/create_room.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies via GetIt service locator.
Future<void> initDependencies() async {
  // ── Core ──
  sl.registerLazySingleton(() => ThemeCubit());

  // ══════════════════════════════════════════
  //  Auth Feature
  // ══════════════════════════════════════════
  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithEmail(sl()));
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginWithEmail: sl(),
        registerWithEmail: sl(),
        sendOtp: sl(),
        verifyOtp: sl(),
      ));

  // ══════════════════════════════════════════
  //  Home / Rooms Feature
  // ══════════════════════════════════════════
  // Data sources
  sl.registerLazySingleton<RoomRemoteDatasource>(
    () => RoomRemoteDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserRooms(sl()));
  sl.registerLazySingleton(() => CreateRoom(sl()));

  // BLoC
  sl.registerFactory(() => HomeBloc(
        getUserRooms: sl(),
        createRoom: sl(),
        repository: sl(),
      ));
}
