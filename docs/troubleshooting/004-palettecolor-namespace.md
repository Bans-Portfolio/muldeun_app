# 004. PaletteColor 네임스페이스 충돌

## 환경
- Flutter 3.44.0
- 발생 위치: `lib/data/services/photo_service.dart`
- 관련 패키지: `palette_generator`

## 문제 상황
`flutter run` 빌드 중 컴파일 에러가 발생했다.

```
lib/data/services/photo_service.dart:10:1: Error: 'PaletteColor' is imported from both
'package:muldeun/core/theme/app_colors.dart' and
'package:palette_generator/palette_generator.dart'.
```

## 원인
`PaletteColor`라는 동일한 이름이 두 곳에서 동시에 import되어 충돌했다.
- 앱 자체에서 정의한 `PaletteColor` enum (11가지 색상 카테고리) — `app_colors.dart`
- `palette_generator` 패키지가 제공하는 `PaletteColor` 클래스

Dart는 같은 이름이 두 출처에서 들어오면 어느 것을 가리키는지 결정할 수 없어 컴파일을 중단한다.

## 해결 과정
패키지 쪽 `PaletteColor`는 이 파일에서 사용하지 않으므로, import 시 `hide`로 제외했다.

```dart
// 변경 전
import 'package:palette_generator/palette_generator.dart';

// 변경 후
import 'package:palette_generator/palette_generator.dart' hide PaletteColor;
```

저장 후 재실행하여 충돌 해소를 확인.

## 결과 / 배운 점
- 컴파일 성공.
- **이 `hide PaletteColor`는 제거하면 안 된다.** 제거 시 동일한 충돌이 재발한다.
- 외부 패키지와 앱 내부 식별자의 이름이 겹칠 수 있으며, Dart의 `hide` / `show` / `as`(별칭)로 import 범위를 제어할 수 있음을 학습.
