import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/room_model.dart';
import '../../core/services/supabase_service.dart';

/// Controller for the Home screen — fetches and manages the user's rooms.
///
/// Uses a Supabase realtime subscription on `room_members` to auto-update
/// when the user is added to a new room.
class HomeController extends GetxController {
  final rooms = <RoomModel>[].obs;
  final isLoading = true.obs;

  StreamSubscription? _realtimeSubscription;

  /// Current user's first name for greeting.
  String get firstName {
    final fullName = SupabaseService.currentUser?.userMetadata?['full_name']
            as String? ??
        '';
    return fullName.split(' ').first.isNotEmpty
        ? fullName.split(' ').first
        : 'there';
  }

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
    _subscribeToRoomChanges();
  }

  /// Fetch rooms where the current user is a member.
  Future<void> fetchRooms() async {
    isLoading.value = true;
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return;

      // Query room_members joined with rooms
      final data = await SupabaseService.client
          .from('room_members')
          .select('room_id, role, rooms(*)')
          .eq('user_id', userId)
          .order('joined_at', ascending: false);

      final List<RoomModel> roomList = [];
      for (final row in data) {
        if (row['rooms'] != null) {
          roomList.add(RoomModel.fromJson(
              Map<String, dynamic>.from(row['rooms'])));
        }
      }
      rooms.value = roomList;
    } catch (e) {
      // Silently handle — table may not exist yet
      rooms.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Subscribe to realtime changes on room_members for this user.
  void _subscribeToRoomChanges() {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return;

    final channel = SupabaseService.client
        .channel('home_room_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'room_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            // Re-fetch rooms on any change
            fetchRooms();
          },
        )
        .subscribe();

    // Store a fake subscription — we'll unsubscribe from the channel directly
    _realtimeSubscription = Stream.empty().listen((_) {});
    // Keep reference to channel for cleanup
    _channel = channel;
  }

  RealtimeChannel? _channel;

  /// Pull-to-refresh support.
  Future<void> refreshRooms() async => fetchRooms();

  @override
  void onClose() {
    _realtimeSubscription?.cancel();
    if (_channel != null) {
      SupabaseService.client.removeChannel(_channel!);
    }
    super.onClose();
  }
}
