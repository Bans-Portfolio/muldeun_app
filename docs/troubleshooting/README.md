# 트러블슈팅 기록 (Troubleshooting Log)

물든(muldeun) 앱을 Flutter로 개발하면서 마주친 문제들과 그 해결 과정을 기록합니다.
데이터 분석(Python, SQL) 배경에서 Flutter·모바일 개발을 처음 접하며 겪은 시행착오를 남깁니다.

## 환경

- **Flutter** 3.44.0 / Dart 3.12.0
- **개발 타깃** Chrome (web) — 개발 중 미리보기
- **백엔드** Firebase (Auth, Firestore, Storage / Blaze)
- **상태관리** Riverpod · **라우팅** go_router
- **OS** Windows

## 문제 목록

### 환경 설정
| 번호 | 문제 | 상태 |
|------|------|------|
| [001](001-flutter-sdk-install.md) | Flutter SDK 설치 및 PATH 환경변수 설정 | ✅ 해결 |
| [002](002-firebase-project-duplicate.md) | Firebase 프로젝트 중복으로 인한 선택 혼란 | ✅ 해결 |
| [003](003-pretendard-font-asset.md) | Pretendard 폰트 asset entry 에러 | ✅ 해결 |

### 코드 / 빌드 오류
| 번호 | 문제 | 상태 |
|------|------|------|
| [004](004-palettecolor-namespace.md) | PaletteColor 네임스페이스 충돌 | ✅ 해결 |
| [005](005-cors-image-loading.md) | Firebase Storage 이미지 CORS 로드 실패 | ✅ 해결 |
| [006](006-diary-card-overflow.md) | 다이어리 카드 BOTTOM OVERFLOWED | ✅ 해결 |

### 배포 / 협업
| 번호 | 문제 | 상태 |
|------|------|------|
| [007](007-git-merge-conflict.md) | Git add/add 병합 충돌로 push 거부 | ✅ 해결 |
| [008](008-onboarding-svg-sizing.md) | 온보딩 SVG 일러스트 사이징 | 🚧 진행 중 |
