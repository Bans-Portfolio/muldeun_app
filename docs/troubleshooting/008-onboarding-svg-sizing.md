# 008. 온보딩 SVG 일러스트 사이징 (진행 중)

## 환경
- Flutter 3.44.0 / Chrome (web)
- 관련 파일: `lib/features/onboarding/screens/onboarding_screen.dart`
- 에셋: `assets/illustrations/onboard_1.svg` ~ `onboard_5.svg` (Figma export)
- 패키지: `flutter_svg`

## 문제 상황
Figma에서 export한 온보딩 5장 SVG를 화면에 넣었는데, Figma 프로토타입에 비해 일러스트 주변 **여백이 과도하게** 남아 작고 허전하게 보인다.

## 원인 (추정)
- `BoxFit.contain`은 일러스트 전체가 잘리지 않도록 영역 안에 모두 담는 방식이라, Figma export 시 그림 바깥에 포함된 빈 viewBox 영역까지 그대로 표시된다.
- 목표 디자인(카드가 화면 폭을 거의 채움, `BoxFit.cover`로 자연 클리핑, `borderRadius: 24`)에 비해, 현재 코드는 카드 컨테이너 없이 `contain`만 적용된 상태다.

## 해결 시도
- 카드에서 `AspectRatio`를 제거하고 `Expanded` 적용
- 가로 패딩 16px
- `BoxFit.cover` + `Alignment.center`

→ 비교 결과 프로토타입과 여전히 차이가 있어, 일러스트 주변 여백이 남는 상태.

## 현재 상태
🚧 **미해결.** SVG 내부 viewBox에 실제로 여백이 포함되어 있는지 확인이 필요하다.
다음 방향으로 좁혀가는 중:
- 코드에서 `cover`로 잘라낼지,
- 아니면 SVG 자체의 여백을 정리할지(viewBox 조정).

## 메모
- 구조 변경(카드/레이아웃)은 Hot Reload로 반영되지 않아 **전체 재시작**(`q` 후 `flutter run -d chrome`)이 필요하다.
