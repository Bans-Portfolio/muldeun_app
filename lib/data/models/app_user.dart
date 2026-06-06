import 'package:cloud_firestore/cloud_firestore.dart';

/// 앱 사용자 정보
/// Firebase Auth의 기본 정보 + 우리 앱 고유 정보(닉네임 등)
class AppUser {
  final String uid;          // Firebase에서 자동 부여하는 고유 ID
  final String email;
  final String displayName;  // 사용자 닉네임 (홈에서 "OO님"으로 표시)
  final String? photoUrl;    // 프로필 사진 (구글 로그인 시 자동)
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String,
      photoUrl: data['photoUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
