import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_router.dart';

/// 온보딩 화면 — SVG에 흰 카드 + 일러스트가 모두 들어있어서 그대로 표시
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: '하나만 남겨도 충분해요!',
      subtitle: '음악, 감정, 문장 중\n지금의 마음 하나만 기록해보세요',
      assetPath: 'assets/illustrations/onboard_1.svg',
    ),
    _OnboardingPage(
      title: '사진 속 색을 모아보세요!',
      subtitle: '사진 속 순간들이\n하나의 팔레트가 돼요.',
      assetPath: 'assets/illustrations/onboard_2.svg',
    ),
    _OnboardingPage(
      title: '조금씩 물드는 캔버스!',
      subtitle: '사진이 담긴 기록들이\n색을 더해가요.',
      assetPath: 'assets/illustrations/onboard_3.svg',
    ),
    _OnboardingPage(
      title: '조용히 쌓이는 하루!',
      subtitle: '나에게만 남기는\n작은 기록들.',
      assetPath: 'assets/illustrations/onboard_4.svg',
    ),
    _OnboardingPage(
      title: '이제 산책을 시작해볼까요?\n오늘의 색을 만나보세요!',
      subtitle: '',
      assetPath: 'assets/illustrations/onboard_5.svg',
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goToNext() {
    if (_isLastPage) {
      context.go(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() => context.go(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    _isLastPage ? '' : '건너뛰기',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _OnboardingPageView(
                  page: _pages[i],
                ),
              ),
            ),
            _PageIndicator(
              count: _pages.length,
              currentIndex: _currentPage,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                onPressed: _goToNext,
                child: Text(
                  _isLastPage ? '시작하기' : '다음',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final String assetPath;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG에 흰 카드 + 일러스트가 들어있으므로 그대로 표시
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                page.assetPath,
                fit: BoxFit.contain,
                placeholderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          if (page.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
