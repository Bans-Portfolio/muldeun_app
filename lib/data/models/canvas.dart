import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';

/// 캔버스 — 사용자가 채워나가는 컬러링북 도안
/// 각 도안은 색상별 필요 칸 수가 정해져 있고, 사용자의 기록으로 채워짐
class Canvas {
  final String id;
  final String userId;
  final String templateId;      // 도안 종류 (예: capybara_walk)
  final String title;
  final String thumbnailUrl;
  final Map<PaletteColor, int> requiredCells; // 색상별 필요 칸 수
  final Map<PaletteColor, int> filledCells;   // 색상별 현재 채워진 칸 수
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  const Canvas({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.title,
    required this.thumbnailUrl,
    required this.requiredCells,
    required this.filledCells,
    required this.isCompleted,
    required this.startedAt,
    this.completedAt,
  });

  /// 전체 진행률 (0.0 ~ 1.0)
  double get progress {
    final totalRequired = requiredCells.values.fold(0, (a, b) => a + b);
    final totalFilled = filledCells.values.fold(0, (a, b) => a + b);
    if (totalRequired == 0) return 0;
    return (totalFilled / totalRequired).clamp(0.0, 1.0);
  }

  /// 총 필요 칸 수
  int get totalRequired =>
      requiredCells.values.fold(0, (a, b) => a + b);

  /// 총 채워진 칸 수
  int get totalFilled =>
      filledCells.values.fold(0, (a, b) => a + b);

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'templateId': templateId,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
        'requiredCells': requiredCells.map(
          (k, v) => MapEntry(k.name, v),
        ),
        'filledCells': filledCells.map(
          (k, v) => MapEntry(k.name, v),
        ),
        'isCompleted': isCompleted,
        'startedAt': Timestamp.fromDate(startedAt),
        'completedAt':
            completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      };

  factory Canvas.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    Map<PaletteColor, int> parseColorMap(Map<String, dynamic>? map) {
      if (map == null) return {};
      return map.map((key, value) {
        final color = PaletteColor.values.firstWhere(
          (e) => e.name == key,
          orElse: () => PaletteColor.gray,
        );
        return MapEntry(color, value as int);
      });
    }

    return Canvas(
      id: doc.id,
      userId: data['userId'] as String,
      templateId: data['templateId'] as String,
      title: data['title'] as String,
      thumbnailUrl: data['thumbnailUrl'] as String,
      requiredCells: parseColorMap(data['requiredCells']),
      filledCells: parseColorMap(data['filledCells']),
      isCompleted: data['isCompleted'] as bool? ?? false,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}
