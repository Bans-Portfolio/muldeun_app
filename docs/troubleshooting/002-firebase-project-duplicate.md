# 002. Firebase 프로젝트 중복으로 인한 선택 혼란

## 환경
- Firebase CLI / FlutterFire CLI
- Firebase 계정: kingban0411@gmail.com

## 문제 상황
`flutterfire configure` 실행 시 프로젝트 선택 목록에 비슷한 이름이 두 개 나타났다.

```
muldeun-project          (439436022057)
muldeun-project-756fd    (187017404151)
```

어느 것이 실제로 사용 중인 프로젝트인지 알 수 없어 잘못 선택하면 설정이 엉킬 위험이 있었다.

## 원인
- 과거 프로젝트 생성 과정에서 한 번 실패한 잔여 프로젝트가 그대로 남아 있었다.
- 두 프로젝트 이름이 거의 같아 CLI 목록만으로는 구분이 어려웠다.

## 해결 과정
1. Firebase 콘솔에 접속해 실제 사용 중인 프로젝트의 URL을 확인.
2. 콘솔 URL 기준 실제 프로젝트가 **`muldeun-project-756fd`** 임을 특정 (Project ID 끝의 `-756fd`가 식별자).
3. `flutterfire configure`에서 `muldeun-project-756fd`를 선택.
4. `firebase_options.dart`가 올바른 프로젝트로 생성됨을 확인.

## 결과 / 배운 점
- 올바른 프로젝트로 web/android/ios 설정 완료.
- 이름이 비슷한 리소스는 **Project ID(고유 식별자)로 구분**해야 한다는 점을 확인. 잔여 프로젝트는 추후 정리 예정.
