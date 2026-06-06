import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 캔버스 화면 — 프로토타입 이미지 11
/// 현재 진행 중인 컬러링북 도안 + 색상별 진행률
class CanvasScreen extends StatelessWidget {
  const CanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터 — 추후 Provider에서 받아옴
    const canvasTitle = '카피바라 산책';
    final colorProgress = [
      _ColorProgress(PaletteColor.red, 0, 3),
      _ColorProgress(PaletteColor.yellow, 0, 8),
      _ColorProgress(PaletteColor.green, 0, 6),
      _ColorProgress(PaletteColor.blue, 0, 2),
      _ColorProgress(PaletteColor.brown, 1, 3),
      _ColorProgress(PaletteColor.white, 0, 1),
    ];

    final totalFilled =
        colorProgress.fold(0, (sum, c) => sum + c.filled);
    final totalRequired =
        colorProgress.fold(0, (sum, c) => sum + c.required);

    return Scaffold(
      appBar: AppBar(title: const Text(canvasTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '전체 $totalFilled/$totalRequired',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colorProgress
                  .map((c) => _ColorChip(progress: c))
                  .toList(),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '이 캔버스에 담긴 기록',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            // TODO: 이 캔버스에 사용된 기록들 그리드 표시
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('아직 기록이 없어요'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorProgress {
  final PaletteColor color;
  final int filled;
  final int required;

  const _ColorProgress(this.color, this.filled, this.required);
}

class _ColorChip extends StatelessWidget {
  final _ColorProgress progress;

  const _ColorChip({required this.progress});

  @override
  Widget build(BuildContext context) {
    final isComplete = progress.filled >= progress.required;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: progress.color.color, width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: progress.color.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${progress.filled}/${progress.required}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isComplete
                  ? progress.color.color
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
