# 005. Firebase Storage 이미지 CORS 로드 실패

## 환경
- Flutter 3.44.0 / Chrome (web)
- Firebase Storage (Blaze)
- 관련 파일: `lib/shared/widgets/record_cards.dart`

## 문제 상황
사진은 Firebase Storage에 정상 업로드되는데, 웹(Chrome)에서 홈·다이어리·상세 화면 모두 사진 자리에 **깨진 이미지 아이콘**만 표시됐다. 업로드와 Firestore 저장은 정상이었다.

## 원인
Firebase Storage의 기본 CORS 정책이 외부 도메인에서의 이미지 접근을 차단한다. 이 문제는 **웹(브라우저)에서만 발생**하며, 모바일 앱 환경에서는 나타나지 않는다.
추가로, 초기에 사용한 `cached_network_image` 패키지가 웹에서 CORS 처리에 더 민감하게 동작했다.

## 해결 과정
두 단계로 접근했다.

1. **이미지 위젯 교체** — `cached_network_image` → 표준 `Image.network`로 전환.
   Flutter 웹 기본 이미지 로더가 CORS를 더 무난히 처리한다.

2. **Storage CORS 정책 직접 허용** — 별도 설치 없이 Google Cloud Shell에서 처리.
   ```bash
   echo '[{"origin":["*"],"method":["GET"],"maxAgeSeconds":3600}]' > cors.json
   gsutil cors set cors.json gs://muldeun-project-756fd.firebasestorage.app
   ```

설정 후 앱을 새로고침(F5)하여 이미지 정상 표시를 확인.

## 결과 / 배운 점
- 웹에서 사진이 정상적으로 로드됨.
- **CORS는 웹 전용 이슈**이며 최종 타깃인 모바일에서는 발생하지 않는다는 점을 이해.
- 클라이언트(위젯 교체)와 서버(Storage CORS 정책) 양쪽에서 접근할 수 있는 문제임을 학습. 버킷 주소는 `.firebasestorage.app` 도메인을 사용.
