import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';
import 'create_room_controller.dart';
import 'widgets/emoji_picker_row.dart';

/// Screen for creating a new room.
class CreateRoomScreen extends GetView<CreateRoomController> {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Create a Room', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ═══════════════════════════════════
            //  Room Name
            // ═══════════════════════════════════
            _fieldLabel('Room Name'),
            const SizedBox(height: 8),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller.nameController,
                      maxLength: 40,
                      onChanged: controller.onNameChanged,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'e.g. Goa Trip 2025, Flatmates, Office Team',
                        hintStyle: AppTextStyles.caption,
                        filled: true,
                        fillColor: AppColors.inputFill,
                        counterText:
                            '${controller.nameLength.value}/40',
                        counterStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.error, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        errorText: controller.nameError.value,
                        prefixIcon: const Icon(Icons.meeting_room_outlined,
                            color: AppColors.grey400),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 8),

            // ═══════════════════════════════════
            //  Room Description
            // ═══════════════════════════════════
            _fieldLabel('Description (optional)'),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
                  controller: controller.descriptionController,
                  maxLength: 120,
                  maxLines: 3,
                  minLines: 1,
                  onChanged: controller.onDescChanged,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: "What's this room for?",
                    hintStyle: AppTextStyles.caption,
                    filled: true,
                    fillColor: AppColors.inputFill,
                    counterText:
                        '${controller.descLength.value}/120',
                    counterStyle: AppTextStyles.caption,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    prefixIcon: const Icon(Icons.description_outlined,
                        color: AppColors.grey400),
                  ),
                )),
            const SizedBox(height: 20),

            // ═══════════════════════════════════
            //  Emoji Picker
            // ═══════════════════════════════════
            _fieldLabel('Choose an Icon'),
            const SizedBox(height: 4),
            Text(
              'This emoji will appear on your room card',
              style: AppTextStyles.caption.copyWith(color: AppColors.grey400),
            ),
            const SizedBox(height: 12),
            Obx(() => EmojiPickerRow(
                  emojis: CreateRoomController.availableEmojis,
                  selectedEmoji: controller.selectedEmoji.value,
                  onEmojiSelected: controller.selectEmoji,
                )),
            const SizedBox(height: 36),

            // ═══════════════════════════════════
            //  Create Button
            // ═══════════════════════════════════
            Obx(() => CustomButton(
                  label: 'Create Room',
                  isLoading: controller.isLoading.value,
                  onTap: controller.createRoom,
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
