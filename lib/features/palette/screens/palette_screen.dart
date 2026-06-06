import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../record/providers/record_provider.dart';
import 'palette_detail_screen.dart';

/// 팔레트 화면 — 11개 색상 카드 그리드
class PaletteScreen extends ConsumerWidget {
  const PaletteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countsAsync = ref.watch(colorCountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('팔레트')),
      body: countsAsync.when(
        data: (counts) => _buildGrid(context, counts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            '팔레트를 불러올 수 없어요',
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, Map<PaletteColor, int> counts) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: PaletteColor.values.length,
      itemBuilder: (context, i) {
        final color = PaletteColor.values[i];
        final count = counts[color] ?? 0;
        return _PaletteCard(
          color: color,
          count: count,
          onTap: count > 0
              ? () => _openDetail(context, color)
              : () => _showEmpty(context, color),
        );
      },
    );
  }

  void _openDetail(BuildContext context, PaletteColor color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaletteDetailScreen(color: color),
      ),
    );
  }

  void _showEmpty(BuildContext context, PaletteColor color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${color.label} 사진이 아직 없어요. 한 장 찍어보세요!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _PaletteCard extends StatelessWidget {
  final PaletteColor color;
  final int count;
  final VoidCallback onTap;

  const _PaletteCard({
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = color == PaletteColor.white;
    final textColor = isLight ? AppColors.textPrimary : Colors.white;

    return Material(
      color: color.color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  color.label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                count.toString(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
