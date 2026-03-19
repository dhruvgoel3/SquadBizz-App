import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/invite_sheet.dart';

/// Controller for the Create Room screen.
///
/// Handles form validation, unique room code generation,
/// Supabase inserts for rooms + room_members + activity_feed,
/// and shows the InviteSheet on success.
class CreateRoomController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // ── Reactive state ──
  final selectedEmoji = '👥'.obs;
  final isLoading = false.obs;
  final nameError = RxnString();
  final nameLength = 0.obs;
  final descLength = 0.obs;

  static const List<String> availableEmojis = [
    '🏖️', '✈️', '🏠', '🍕', '🎉', '💼', '🏕️', '🎮', '💰', '👥',
  ];

  void onNameChanged(String value) {
    nameLength.value = value.length;
    if (value.trim().isNotEmpty) nameError.value = null;
  }

  void onDescChanged(String value) {
    descLength.value = value.length;
  }

  void selectEmoji(String emoji) {
    selectedEmoji.value = emoji;
  }

  // ──────────────────────────────────────────────
  //  CREATE ROOM
  // ──────────────────────────────────────────────

  Future<void> createRoom() async {
    // Validate
    final name = nameController.text.trim();
    if (name.isEmpty) {
      nameError.value = 'Room name is required';
      return;
    }
    if (name.length < 2) {
      nameError.value = 'Room name must be at least 2 characters';
      return;
    }
    nameError.value = null;

    isLoading.value = true;
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Not authenticated');

      final userName = SupabaseService.currentUser?.userMetadata?['full_name']
              as String? ??
          'Someone';

      // 1. Generate unique room code
      final roomCode = await _generateUniqueCode();

      // 2. Insert room
      final response = await SupabaseService.client
          .from('rooms')
          .insert({
            'name': name,
            'description': descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim(),
            'emoji': selectedEmoji.value,
            'room_code': roomCode,
            'created_by': userId,
          })
          .select('id')
          .single();

      final roomId = response['id'] as String;

      // 3. Add creator as admin member
      await SupabaseService.client.from('room_members').insert({
        'room_id': roomId,
        'user_id': userId,
        'role': 'admin',
      });

      // 4. Add activity entry
      await SupabaseService.client.from('activity_feed').insert({
        'room_id': roomId,
        'user_id': userId,
        'type': 'room_created',
        'message': '$userName created the room',
      });

      // 5. Show invite sheet, then navigate to room
      await Get.bottomSheet(
        InviteSheet(
          roomCode: roomCode,
          onContinue: () {
            Get.back(); // Close sheet
            Get.offNamed(
              AppRoutes.roomDashboard,
              arguments: {'roomId': roomId},
            );
          },
        ),
        isDismissible: false,
        isScrollControlled: true,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        _friendlyError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //  ROOM CODE GENERATOR
  // ──────────────────────────────────────────────

  /// Generate a random 6-character alphanumeric code (A-Z, 0-9).
  /// Verifies uniqueness against the rooms table.
  Future<String> _generateUniqueCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    for (int attempt = 0; attempt < 10; attempt++) {
      final code = String.fromCharCodes(
        Iterable.generate(
            6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
      );

      // Check uniqueness
      final existing = await SupabaseService.client
          .from('rooms')
          .select('id')
          .eq('room_code', code)
          .maybeSingle();

      if (existing == null) return code;
    }

    // Extremely unlikely fallback
    throw Exception('Unable to generate unique room code.');
  }

  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return 'Please check your internet connection.';
    }
    if (raw.contains('duplicate') || raw.contains('unique')) {
      return 'A room with this code already exists. Please try again.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong. Please try again.';
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
