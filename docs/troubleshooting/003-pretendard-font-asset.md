# 003. Pretendard 폰트 asset entry 에러

## 환경
- Flutter 3.44.0 / Chrome (web)
- 발생 명령: `flutter run -d chrome`

## 문제 상황
앱을 처음 실행하려 할 때 빌드가 실패하며 다음 에러가 발생했다.

```
unable to locate asset entry in pubspec.yaml:
"assets/fonts/Pretendard-Regular.ttf"
```

## 원인
`pubspec.yaml`의 `fonts:` 섹션에 Pretendard 폰트 3종(Regular/Medium/Bold)을 선언해 두었지만, 실제 `.ttf` 파일이 `assets/fonts/` 폴더에 존재하지 않았다. Flutter는 선언된 asset 경로에 실제 파일이 없으면 빌드를 중단한다.

## 해결 과정
화면 흐름 확인이 먼저였기 때문에 단계적으로 처리했다.
1. **임시 조치** — `pubspec.yaml`의 `fonts:` 섹션 전체를 주석 처리해 시스템 기본 폰트로 빌드를 통과시킴.
2. 화면 동작 확인 후, 실제 Pretendard `.ttf` 파일을 `assets/fonts/`에 추가.
3. 주석을 해제하고 `flutter pub get` → 재실행하여 폰트 정상 적용.

## 결과 / 배운 점
- 폰트 적용 완료 및 빌드 통과.
- `pubspec.yaml`의 asset 선언은 **실제 파일 존재가 전제 조건**이다. 선언과 파일은 항상 짝을 맞춰야 한다.
- 막히는 작업이 본질이 아닐 때는 **임시 우회 → 본 작업 → 나중에 정식 처리** 순서가 효율적이다.
