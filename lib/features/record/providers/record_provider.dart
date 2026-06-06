import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/record_entry.dart';
import '../../../data/repositories/record_repository.dart';
import '../../../data/services/photo_service.dart';

/// PhotoService 인스턴스
final photoServiceProvider = Provider<PhotoService>((ref) => PhotoService());

/// RecordRepository 인스턴스
final recordRepositoryProvider =
    Provider<RecordRepository>((ref) => RecordRepository());

/// 색상별 기록 개수 (실시간)
final colorCountsProvider = StreamProvider<Map<PaletteColor, int>>((ref) {
  return ref.watch(recordRepositoryProvider).watchColorCounts();
});

/// 모든 기록 (실시간, 최신순)
final allRecordsProvider = StreamProvider<List<RecordEntry>>((ref) {
  return ref.watch(recordRepositoryProvider).watchAll();
});
