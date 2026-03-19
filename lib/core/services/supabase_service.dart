import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton wrapper around the Supabase client.
///
/// Call [SupabaseService.init] once in `main()` before using the client.
/// Then access the client anywhere via [SupabaseService.client].
class SupabaseService {
  SupabaseService._();

  // Initialization is now properly handled in main.dart

  /// The global Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shortcut to the auth module.
  static GoTrueClient get auth => client.auth;

  /// The current logged-in user (null if not authenticated).
  static User? get currentUser => auth.currentUser;

  /// Whether a user session is currently active.
  static bool get isLoggedIn => auth.currentSession != null;

  /// Insert a new row into the `profiles` table.
  static Future<void> createProfile({
    required String id,
    required String fullName,
    String? email,
    String? phone,
  }) async {
    await client.from('profiles').insert({
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
    });
  }
}
