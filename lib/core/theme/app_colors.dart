import 'package:flutter/material.dart';

/// 물든 앱의 컬러 시스템
/// 프로토타입의 메인 블루와 11가지 팔레트 색상을 정의합니다.
class AppColors {
  AppColors._();

  // 브랜드 컬러
  static const Color primary = Color(0xFF2B7FFF); // 메인 블루
  static const Color primaryLight = Color(0xFFD7E8FF);
  static const Color primaryDark = Color(0xFF1E5FCC);

  // 배경
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F8FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // 텍스트
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFFA0A4AB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // 보더/디바이더
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF0F1F4);

  // 상태
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  /// 팔레트 11색 — 사용자의 사진에서 추출되어 분류될 색상 카테고리
  static const Map<PaletteColor, Color> palette = {
    PaletteColor.red: Color(0xFFEF6B6B),
    PaletteColor.orange: Color(0xFFF59E5B),
    PaletteColor.yellow: Color(0xFFFCD34D),
    PaletteColor.green: Color(0xFF7DC97D),
    PaletteColor.blue: Color(0xFF7BB8E8),
    PaletteColor.purple: Color(0xFFB87DD9),
    PaletteColor.pink: Color(0xFFEC6B98),
    PaletteColor.brown: Color(0xFF8B6F47),
    PaletteColor.gray: Color(0xFF6B7280),
    PaletteColor.white: Color(0xFFF3F4F6),
    PaletteColor.black: Color(0xFF1F2937),
  };
}

/// 팔레트 색상 카테고리
enum PaletteColor {
  red,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  brown,
  gray,
  white,
  black;

  String get label {
    switch (this) {
      case PaletteColor.red:
        return '빨간색';
      case PaletteColor.orange:
        return '주황색';
      case PaletteColor.yellow:
        return '노란색';
      case PaletteColor.green:
        return '초록색';
      case PaletteColor.blue:
        return '파란색';
      case PaletteColor.purple:
        return '보라색';
      case PaletteColor.pink:
        return '분홍색';
      case PaletteColor.brown:
        return '갈색';
      case PaletteColor.gray:
        return '회색';
      case PaletteColor.white:
        return '하얀색';
      case PaletteColor.black:
        return '검은색';
    }
  }

  Color get color => AppColors.palette[this]!;
}
