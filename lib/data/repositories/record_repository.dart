import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import '../models/record_entry.dart';

/// 기록(RecordEntry) Firestore 저장소
class RecordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 현재 사용자의 기록 컬렉션 참조
  CollectionReference<Map<String, dynamic>> _userRecords() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('records');
  }

  /// 새 기록 추가
  Future<String> add(RecordEntry record) async {
    final docRef = await _userRecords().add(record.toFirestore());
    return docRef.id;
  }

  /// 사용자의 모든 기록 조회 (최신순)
  Future<List<RecordEntry>> getAll() async {
    final snapshot = await _userRecords()
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => RecordEntry.fromFirestore(doc)).toList();
  }

  /// 특정 색상의 기록만 조회
  Future<List<RecordEntry>> getByColor(PaletteColor color) async {
    final snapshot = await _userRecords()
        .where('selectedColor', isEqualTo: color.name)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => RecordEntry.fromFirestore(doc)).toList();
  }

  /// 색상별 기록 개수 통계
  Future<Map<PaletteColor, int>> getColorCounts() async {
    final snapshot = await _userRecords().get();
    final counts = <PaletteColor, int>{};

    // 모든 카테고리를 0으로 초기화
    for (final color in PaletteColor.values) {
      counts[color] = 0;
    }

    // 실제 데이터로 카운트
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final colorName = data['selectedColor'] as String?;
      if (colorName == null) continue;

      final color = PaletteColor.values.firstWhere(
        (c) => c.name == colorName,
        orElse: () => PaletteColor.gray,
      );
      counts[color] = (counts[color] ?? 0) + 1;
    }

    return counts;
  }

  /// 기록 삭제
  Future<void> delete(String recordId) async {
    await _userRecords().doc(recordId).delete();
  }

  /// 실시간 기록 스트림 (자동 업데이트)
  Stream<List<RecordEntry>> watchAll() {
    return _userRecords()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecordEntry.fromFirestore(doc))
            .toList());
  }

  /// 색상별 카운트 실시간 스트림
  Stream<Map<PaletteColor, int>> watchColorCounts() {
    return _userRecords().snapshots().map((snapshot) {
      final counts = <PaletteColor, int>{};
      for (final color in PaletteColor.values) {
        counts[color] = 0;
      }
      for (final doc in snapshot.docs) {
        final colorName = doc.data()['selectedColor'] as String?;
        if (colorName == null) continue;
        final color = PaletteColor.values.firstWhere(
          (c) => c.name == colorName,
          orElse: () => PaletteColor.gray,
        );
        counts[color] = (counts[color] ?? 0) + 1;
      }
      return counts;
    });
  }
}
