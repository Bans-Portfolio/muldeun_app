# 물든 (muldeun)

> 같은 하늘에서, 하루를 물들이다

사진 속 색을 추출해 하루를 기록하고, 모인 색이 캔버스를 채워나가는 감성 기록 앱.

## 기술 스택

| 영역 | 사용 기술 |
|------|-----------|
| 프레임워크 | Flutter 3.19+ |
| 상태관리 | Riverpod |
| 라우팅 | go_router |
| 백엔드 | Firebase (Auth, Firestore, Storage) |
| 위치 API | 카카오맵 로컬 API |
| 색상 추출 | palette_generator |
| 로컬 캐시 | Hive, SharedPreferences |

## 폴더 구조

```
lib/
├── core/
│   ├── constants/      # 앱 전역 상수
│   ├── theme/          # 색상, 타이포그래피, 테마
│   └── utils/          # 라우터, 헬퍼
├── data/
│   ├── models/         # 데이터 모델 (RecordEntry, Canvas 등)
│   ├── repositories/   # 데이터 접근 계층
│   └── services/       # Firebase, 카카오맵 등 외부 서비스
├── features/
│   ├── onboarding/     # 온보딩 5장 슬라이드
│   ├── auth/           # 소셜 로그인
│   ├── home/           # 홈 + 하단 탭바
│   ├── record/         # 사진 기록 작성
│   ├── canvas/         # 컬러링북 진행
│   └── palette/        # 색상별 갤러리
└── shared/             # 공통 위젯
```

## 1차 구현 범위 (MVP)

- [x] 폴더 구조 및 테마 시스템
- [x] 데이터 모델 정의
- [x] 5개 화면 기본 스켈레톤
  - [x] 온보딩 5장 슬라이드
  - [x] 소셜 로그인
  - [x] 홈 (오늘의 추천 색 + 진행 중 캔버스)
  - [x] 기록 작성 (사진 + 색·위치·음악·감정)
  - [x] 캔버스 (진행률 표시)
  - [x] 팔레트 (11색 그리드)
- [ ] Firebase 연동 (Auth, Firestore, Storage)
- [ ] 카카오맵 로컬 API 연동
- [ ] image_picker 카메라/갤러리 연동
- [ ] palette_generator 색상 추출

## 2차 범위 (후순위)

- 다이어리 화면 (월별 기록 그리드)
- 음악 검색 API 연동
- 캐릭터 도감 시스템 (프로토타입 캐릭터 활용)
- 캔버스 완성 보상 시스템
- 푸시 알림 (오늘의 추천 색)

## 시작하기

```bash
# 1. 의존성 설치
flutter pub get

# 2. Firebase 설정
# firebase_options.dart 파일 생성 후 main.dart 의 주석 해제
flutterfire configure

# 3. 카카오 SDK 설정
# main.dart에서 KAKAO_NATIVE_APP_KEY 입력 후 주석 해제

# 4. 실행
flutter run
```

## 환경 변수

`.env` 파일 또는 `--dart-define`로 다음 키를 주입해야 합니다.

| 키 | 용도 |
|------|------|
| KAKAO_NATIVE_APP_KEY | 카카오 로그인 |
| KAKAO_REST_API_KEY | 카카오맵 로컬 API |
