import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_user.dart';
import '../../../data/services/auth_service.dart';

/// AuthService 인스턴스 제공
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// 현재 로그인 상태 (Firebase User)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// 현재 로그인된 AppUser 정보 (Firestore에서 가져옴)
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) async {
      if (user == null) return null;
      return ref.watch(authServiceProvider).getCurrentAppUser();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
