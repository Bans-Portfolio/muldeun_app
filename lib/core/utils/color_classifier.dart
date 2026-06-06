import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 색상 분류 유틸리티
/// 사진에서 추출한 RGB 색상을 우리 앱의 11개 팔레트 카테고리 중 하나로 매칭합니다.
class ColorClassifier {
  ColorClassifier._();

  /// 주어진 색상을 11개 팔레트 색상 중 가장 가까운 것으로 분류
  static PaletteColor classify(Color color) {
    final hsl = HSLColor.fromColor(color);
    final hue = hsl.hue;
    final saturation = hsl.saturation;
    final lightness = hsl.lightness;

    // 1. 채도가 매우 낮으면 (회색 계열) - 명도로 판단
    if (saturation < 0.15) {
      if (lightness < 0.2) return PaletteColor.black;
      if (lightness > 0.85) return PaletteColor.white;
      return PaletteColor.gray;
    }

    // 2. 명도가 매우 낮으면 검은색
    if (lightness < 0.1) return PaletteColor.black;
    if (lightness > 0.92) return PaletteColor.white;

    // 3. 갈색 특수 처리 (낮은 명도 + 주황~빨강 계열)
    if (lightness < 0.5 && (hue < 40 || hue > 350) && saturation < 0.6) {
      return PaletteColor.brown;
    }
    if (lightness < 0.45 && hue >= 20 && hue <= 50) {
      return PaletteColor.brown;
    }

    // 4. 색조(Hue)로 분류
    // Hue: 0°(빨강) → 60°(노랑) → 120°(초록) → 180°(시안) → 240°(파랑) → 300°(자홍) → 360°(빨강)
    if (hue < 15 || hue >= 345) {
      // 분홍 vs 빨강 구분 (분홍은 더 밝고 채도 낮음)
      if (lightness > 0.7 && saturation < 0.7) return PaletteColor.pink;
      return PaletteColor.red;
    }
    if (hue >= 15 && hue < 45) return PaletteColor.orange;
    if (hue >= 45 && hue < 70) return PaletteColor.yellow;
    if (hue >= 70 && hue < 165) return PaletteColor.green;
    if (hue >= 165 && hue < 250) return PaletteColor.blue;
    if (hue >= 250 && hue < 310) return PaletteColor.purple;
    if (hue >= 310 && hue < 345) return PaletteColor.pink;

    return PaletteColor.gray; // 기본값
  }

  /// 여러 색상을 분류한 후 가장 많이 나온 카테고리들 반환
  /// PaletteGenerator가 추출한 색상들을 분류해서 대표 색상 후보를 만듭니다.
  static List<PaletteColor> classifyMultiple(List<Color> colors) {
    final counts = <PaletteColor, int>{};
    for (final color in colors) {
      final category = classify(color);
      counts[category] = (counts[category] ?? 0) + 1;
    }
    // 많이 나온 순으로 정렬
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => e.key).toList();
  }

  /// Color를 hex 문자열로 변환 (#RRGGBB)
  static String toHex(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
