import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../diary/screens/record_detail_screen.dart';
import '../../record/providers/record_provider.dart';
import 'main_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final countsAsync = ref.watch(colorCountsProvider);
    final recordsAsync = ref.watch(allRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'muldeun',
                          style:
                              AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          color: Colors.white,
                          onSelected: (value) async {
                            if (value == 'logout') {
                              await ref.read(authServiceProvider).signOut();
                              if (context.mounted) {
                                context.go(AppRoutes.login);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 20),
                                  SizedBox(width: 8),
                                  Text('로그아웃'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    userAsync.when(
                      data: (user) {
                        final name = user?.displayName ?? '사용자';
                        final recommendedColor =
                            _calculateRecommendedColor(countsAsync);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요 $name님',
                              style: AppTextStyles.h2
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.h2
                                    .copyWith(color: Colors.white),
                                children: [
                                  const TextSpan(text: '오늘은 '),
                                  TextSpan(
                                    text: recommendedColor.label,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: '을 추천드려요!'),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => Text(
                        '로딩 중...',
                        style:
                            AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                      error: (_, __) => Text(
                        '안녕하세요!',
                        style:
                            AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () => MainScaffold.goToCamera(context),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('기록하기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(120, 44),
                          textStyle: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: countsAsync.when(
                  data: (counts) {
                    final total = counts.values.fold(0, (a, b) => a + b);
                    if (total == 0) {
                      return _buildEmptyState(context);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('나의 색', style: AppTextStyles.h3),
                            GestureDetector(
                              onTap: () => MainScaffold.goToPalette(context),
                              child: Row(
                                children: [
                                  Text(
                                    '$total개',
                                    style:
                                        AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildColorSummary(counts),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('최근 기록', style: AppTextStyles.h3),
                            GestureDetector(
                              onTap: () => MainScaffold.goToDiary(context),
                              child: Row(
                                children: [
                                  Text(
                                    '전체보기',
                                    style:
                                        AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        recordsAsync.when(
                          data: (records) => _buildRecentRecords(
                            context,
                            records.take(6).toList(),
                          ),
                          loading: () => const SizedBox(
                            height: 100,
                            child:
                                Center(child: CircularProgressIndicator()),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text('아직 기록이 없어요', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 4),
          Text('첫 사진을 기록해보세요', style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => MainScaffold.goToCamera(context),
            child: const Text('지금 시작하기'),
          ),
        ],
      ),
    );
  }

  PaletteColor _calculateRecommendedColor(
      AsyncValue<Map<PaletteColor, int>> countsAsync) {
    return countsAsync.maybeWhen(
      data: (counts) {
        if (counts.values.every((v) => v == 0)) {
          return PaletteColor.brown;
        }
        final sorted = counts.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        return sorted.first.key;
      },
      orElse: () => PaletteColor.brown,
    );
  }

  Widget _buildColorSummary(Map<PaletteColor, int> counts) {
    final entries = counts.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entries
          .take(6)
          .map((entry) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: entry.key.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: entry.key.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.key.label} ${entry.value}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildRecentRecords(BuildContext context, List records) {
    if (records.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: records.length,
      itemBuilder: (context, i) {
        final record = records[i];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecordDetailScreen(record: record),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              record.photoUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                color: AppColors.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 24),
              ),
            ),
          ),
        );
      },
    );
  }
}
