import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';

/// Controller for the Rooms tab — fetches user's rooms from Supabase.
class RoomsController extends GetxController {
  final rooms = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  /// Fetch rooms where the current user is a member.
  Future<void> fetchRooms() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return;

      // Query room_members joined with rooms for the current user
      final data = await SupabaseService.client
          .from('room_members')
          .select('rooms(*)')
          .eq('user_id', userId);

      // Extract room data from the join result
      final List<Map<String, dynamic>> roomList = [];
      for (final row in data) {
        if (row['rooms'] != null) {
          roomList.add(Map<String, dynamic>.from(row['rooms']));
        }
      }
      rooms.value = roomList;
    } catch (e) {
      // Silently handle — rooms table may not exist yet
      rooms.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh support.
  Future<void> refreshRooms() async => fetchRooms();
}
