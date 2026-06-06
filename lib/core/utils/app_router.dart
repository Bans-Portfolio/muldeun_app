import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/screens/email_login_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/home/screens/main_scaffold.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/record/screens/record_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String emailLogin = '/login/email';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String record = '/record';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;

    final isAuthPage = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.emailLogin ||
        state.matchedLocation == AppRoutes.signUp ||
        state.matchedLocation == AppRoutes.onboarding;

    if (isLoggedIn && isAuthPage) {
      return AppRoutes.home;
    }
    if (!isLoggedIn && state.matchedLocation == AppRoutes.home) {
      return AppRoutes.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.emailLogin,
      builder: (context, state) => const EmailLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScaffold(),
    ),
    GoRoute(
      path: AppRoutes.record,
      builder: (context, state) {
        // 카메라/갤러리에서 선택한 사진을 받음
        final photo = state.extra as XFile?;
        if (photo == null) {
          // 사진 없이 접근하면 카메라 화면으로 안내
          return const _NoPhotoScreen();
        }
        return RecordScreen(photo: photo);
      },
    ),
  ],
);

/// 사진 없이 record 화면 접근 시 안내
class _NoPhotoScreen extends StatelessWidget {
  const _NoPhotoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('먼저 사진을 선택해주세요'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('카메라로 가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
