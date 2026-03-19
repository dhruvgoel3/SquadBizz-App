import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';

/// Controller for the Activity tab — fetches recent events from Supabase.
class ActivityController extends GetxController {
  final activities = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivity();
  }

  /// Fetch the activity feed from Supabase.
  Future<void> fetchActivity() async {
    isLoading.value = true;
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return;

      // Try to fetch from activity_feed table
      final data = await SupabaseService.client
          .from('activity_feed')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(30);

      activities.value = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // Silently handle — table may not exist yet
      activities.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshActivity() async => fetchActivity();
}
