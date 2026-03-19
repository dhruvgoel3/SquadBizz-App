import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Horizontal row of selectable emoji icons for room creation.
class EmojiPickerRow extends StatelessWidget {
  final List<String> emojis;
  final String selectedEmoji;
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerRow({
    super.key,
    required this.emojis,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final emoji = emojis[index];
          final isSelected = emoji == selectedEmoji;
          return GestureDetector(
            onTap: () => onEmojiSelected(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
