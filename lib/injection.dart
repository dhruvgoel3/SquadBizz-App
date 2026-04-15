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
import 'features/home/domain/usecases/join_room.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

// ── Feature: Polls ──
import 'features/polls/data/datasources/poll_remote_datasource.dart';
import 'features/polls/data/repositories/poll_repository_impl.dart';
import 'features/polls/domain/repositories/poll_repository.dart';
import 'features/polls/domain/usecases/get_room_polls.dart';
import 'features/polls/domain/usecases/create_poll.dart';
import 'features/polls/domain/usecases/vote_on_poll.dart';
import 'features/polls/presentation/bloc/poll_bloc.dart';

// ── Feature: Expenses ──
import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/repositories/expense_repository.dart';
import 'features/expenses/domain/usecases/get_room_expenses.dart';
import 'features/expenses/domain/usecases/create_expense.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';

// ── Feature: Chat ──
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

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
  sl.registerLazySingleton(() => JoinRoom(sl()));

  // BLoC
  sl.registerFactory(() => HomeBloc(
        getUserRooms: sl(),
        createRoom: sl(),
        joinRoom: sl(),
        repository: sl(),
      ));

  // ══════════════════════════════════════════
  //  Polls Feature
  // ══════════════════════════════════════════
  // Data sources
  sl.registerLazySingleton<PollRemoteDatasource>(
    () => PollRemoteDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<PollRepository>(
    () => PollRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRoomPolls(sl()));
  sl.registerLazySingleton(() => CreatePoll(sl()));
  sl.registerLazySingleton(() => VoteOnPoll(sl()));

  // BLoC
  sl.registerFactory(() => PollBloc(
        getRoomPolls: sl(),
        createPoll: sl(),
        voteOnPoll: sl(),
      ));

  // ══════════════════════════════════════════
  //  Expenses Feature
  // ══════════════════════════════════════════
  // Data sources
  sl.registerLazySingleton<ExpenseRemoteDatasource>(
    () => ExpenseRemoteDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRoomExpenses(sl()));
  sl.registerLazySingleton(() => CreateExpense(sl()));

  // BLoC
  sl.registerFactory(() => ExpenseBloc(
        getRoomExpenses: sl(),
        createExpense: sl(),
      ));

  // ══════════════════════════════════════════
  //  Chat Feature
  // ══════════════════════════════════════════
  // Data sources
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton(() => ChatRepository(sl()));

  // BLoC
  sl.registerFactory(() => ChatBloc(repository: sl()));
}

