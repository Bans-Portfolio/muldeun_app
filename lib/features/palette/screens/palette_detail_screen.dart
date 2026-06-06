import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/record_entry.dart';
import '../../../shared/widgets/record_cards.dart';
import '../../diary/screens/record_detail_screen.dart';
import '../../record/providers/record_provider.dart';

/// 팔레트 상세 화면 - 특정 색상의 사진들 그리드 표시
/// 프로토타입 이미지 14
class PaletteDetailScreen extends ConsumerWidget {
  final PaletteColor color;

  const PaletteDetailScreen({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(allRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(color.label),
          ],
        ),
      ),
      body: recordsAsync.when(
        data: (allRecords) {
          // 선택된 색상의 기록만 필터링
          final filtered = allRecords
              .where((r) => r.selectedColor == color)
              .toList();

          if (filtered.isEmpty) {
            return _buildEmpty();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filtered.length}개의 기록',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final record = filtered[i];
                    return RecordCardSquare(
                      record: record,
                      onTap: () => _openDetail(context, record),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            '기록을 불러올 수 없어요',
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${color.label} 사진이 아직 없어요',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${color.label} 색을 찾아 기록해보세요',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, RecordEntry record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordDetailScreen(record: record),
      ),
    );
  }
}
