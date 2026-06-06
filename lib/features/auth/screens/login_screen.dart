import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    if (kIsWeb) {
      _showInfo('웹에서는 이메일 로그인을 이용해주세요. 모바일 앱에서 구글 로그인이 가능합니다.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      _showError('구글 로그인 실패: ${_friendlyError(e)}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('cancelled') || msg.contains('취소')) {
      return '로그인이 취소되었어요';
    }
    if (msg.contains('network')) return '네트워크 연결을 확인해주세요';
    return msg.replaceAll(RegExp(r'\[.*?\]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    '같은 하늘에서,\n하루를 물들이다',
                    style: AppTextStyles.h1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'muldeun',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.cloud,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('3초만에 시작하기 🚀'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 구글 로그인 (웹에서는 약간 비활성 표시)
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                    ),
                    label: Text(kIsWeb
                        ? 'Google 로그인 (모바일 앱 전용)'
                        : 'Google로 시작하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kIsWeb
                          ? AppColors.surface
                          : Colors.white,
                      foregroundColor: kIsWeb
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 0,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => context.push(AppRoutes.emailLogin),
                    icon: const Icon(Icons.mail_outline, size: 20),
                    label: const Text('이메일로 로그인'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: AppColors.border),
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.push(AppRoutes.signUp),
                          child: Text(
                            '회원가입',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 12,
                          color: AppColors.border,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '문의하기',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
