import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:squadbizz/features/auth/domain/usecases/login_with_email.dart';
import 'package:squadbizz/features/auth/domain/usecases/register_with_email.dart';
import 'package:squadbizz/features/auth/domain/usecases/send_otp.dart';
import 'package:squadbizz/features/auth/domain/usecases/verify_otp.dart';
import 'package:squadbizz/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:squadbizz/features/auth/presentation/bloc/auth_event.dart';
import 'package:squadbizz/features/auth/presentation/bloc/auth_state.dart';

// ── Mocks ──
class MockLoginWithEmail extends Mock implements LoginWithEmail {}

class MockRegisterWithEmail extends Mock implements RegisterWithEmail {}

class MockSendOtp extends Mock implements SendOtp {}

class MockVerifyOtp extends Mock implements VerifyOtp {}

void main() {
  late AuthBloc authBloc;
  late MockLoginWithEmail mockLoginWithEmail;
  late MockRegisterWithEmail mockRegisterWithEmail;
  late MockSendOtp mockSendOtp;
  late MockVerifyOtp mockVerifyOtp;

  setUp(() {
    mockLoginWithEmail = MockLoginWithEmail();
    mockRegisterWithEmail = MockRegisterWithEmail();
    mockSendOtp = MockSendOtp();
    mockVerifyOtp = MockVerifyOtp();

    authBloc = AuthBloc(
      loginWithEmail: mockLoginWithEmail,
      registerWithEmail: mockRegisterWithEmail,
      sendOtp: mockSendOtp,
      verifyOtp: mockVerifyOtp,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('LoginWithEmailEvent', () {
      const email = 'test@example.com';
      const password = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoginSuccess] on successful login',
        build: () {
          when(() => mockLoginWithEmail(email: email, password: password))
              .thenAnswer(
            (_) async => (success: true, error: null),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginWithEmailEvent(email: email, password: password),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthLoginSuccess>(),
        ],
        verify: (_) {
          verify(() =>
                  mockLoginWithEmail(email: email, password: password))
              .called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on failed login',
        build: () {
          when(() => mockLoginWithEmail(email: email, password: password))
              .thenAnswer(
            (_) async => (success: false, error: 'Invalid credentials'),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginWithEmailEvent(email: email, password: password),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
      );
    });

    group('SendOtpEvent', () {
      const phone = '+911234567890';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthOtpSent] on successful OTP send',
        build: () {
          when(() => mockSendOtp(phone: phone, fullName: null)).thenAnswer(
            (_) async => (success: true, error: null),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const SendOtpEvent(phone: phone)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthOtpSent>(),
        ],
      );
    });

    group('VerifyOtpEvent', () {
      const phone = '+911234567890';
      const token = '123456';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthOtpVerified] on successful OTP verify',
        build: () {
          when(() => mockVerifyOtp(phone: phone, token: token)).thenAnswer(
            (_) async => (success: true, error: null),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const VerifyOtpEvent(phone: phone, token: token),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthOtpVerified>(),
        ],
      );
    });

    group('AuthResetEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when reset',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthResetEvent()),
        expect: () => [isA<AuthInitial>()],
      );
    });
  });
}
