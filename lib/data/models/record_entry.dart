import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';

/// 하나의 기록(다이어리 엔트리)
/// 사진 1장 + 메타데이터 + 추출된 색상 정보
class RecordEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String photoUrl;
  final String? location;        // 카카오맵에서 받은 장소명
  final double? latitude;
  final double? longitude;
  final String? musicTitle;       // 추후 음악 API 연동
  final String? musicArtist;
  final String? mood;             // 감정 태그
  final String? note;             // 메모
  final PaletteColor selectedColor; // 사용자가 확정한 대표 색상
  final List<String> extractedColors; // 추출된 색상 hex 코드들
  final String? weather;
  final DateTime createdAt;

  const RecordEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.photoUrl,
    this.location,
    this.latitude,
    this.longitude,
    this.musicTitle,
    this.musicArtist,
    this.mood,
    this.note,
    required this.selectedColor,
    required this.extractedColors,
    this.weather,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'date': Timestamp.fromDate(date),
        'photoUrl': photoUrl,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'musicTitle': musicTitle,
        'musicArtist': musicArtist,
        'mood': mood,
        'note': note,
        'selectedColor': selectedColor.name,
        'extractedColors': extractedColors,
        'weather': weather,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory RecordEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecordEntry(
      id: doc.id,
      userId: data['userId'] as String,
      date: (data['date'] as Timestamp).toDate(),
      photoUrl: data['photoUrl'] as String,
      location: data['location'] as String?,
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      musicTitle: data['musicTitle'] as String?,
      musicArtist: data['musicArtist'] as String?,
      mood: data['mood'] as String?,
      note: data['note'] as String?,
      selectedColor: PaletteColor.values.firstWhere(
        (e) => e.name == data['selectedColor'],
        orElse: () => PaletteColor.gray,
      ),
      extractedColors: List<String>.from(data['extractedColors'] ?? []),
      weather: data['weather'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  RecordEntry copyWith({
    String? location,
    double? latitude,
    double? longitude,
    String? musicTitle,
    String? musicArtist,
    String? mood,
    String? note,
    PaletteColor? selectedColor,
    List<String>? extractedColors,
    String? weather,
  }) {
    return RecordEntry(
      id: id,
      userId: userId,
      date: date,
      photoUrl: photoUrl,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      musicTitle: musicTitle ?? this.musicTitle,
      musicArtist: musicArtist ?? this.musicArtist,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      selectedColor: selectedColor ?? this.selectedColor,
      extractedColors: extractedColors ?? this.extractedColors,
      weather: weather ?? this.weather,
      createdAt: createdAt,
    );
  }
}
