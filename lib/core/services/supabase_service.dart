import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton wrapper around the Supabase client.
///
/// Call [SupabaseService.init] once in `main()` before using the client.
/// Then access the client anywhere via [SupabaseService.client].
class SupabaseService {
  SupabaseService._();

 
  
  static const String _supabaseUrl = 'https://xpjhlskvkyqbfgetbrnn.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhwamhsc2t2a3lxYmZnZXRicm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NDcxMTIsImV4cCI6MjA4OTQyMzExMn0.Ne5KZvaeLKzD_Lsg6l6QMbQCCOpP5PUOAUetbf1_66M';

  /// Initialise Supabase — call once in `main()`.
  static Future<void> init() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

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
