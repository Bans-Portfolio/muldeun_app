# 001. Flutter SDK 설치 및 PATH 환경변수 설정

## 환경
- Windows
- Flutter 3.44.0 (stable, Windows zip)

## 문제 상황
Flutter를 처음 설치하는 과정에서 세 군데에서 막혔다.
1. 공식 다운로드 페이지가 자동 번역되어 `창문`(=Windows), `증명 번들`(=zip 파일 링크)처럼 표시돼 어디를 눌러야 할지 알기 어려웠다.
2. zip 압축을 어디에 풀어야 하는지 판단이 어려웠다.
3. 압축을 풀어도 터미널에서 `flutter` 명령이 인식되지 않았다.

## 원인
- 설치 경로에 한글·공백이 들어가거나 `C:\Program Files\` 하위에 두면 권한·경로 문제로 오류가 발생한다.
- `flutter` 명령은 SDK의 `bin` 폴더가 시스템 PATH에 등록되어 있어야 어느 위치에서나 인식된다. PATH 미등록 시 "명령을 찾을 수 없음" 상태가 된다.

## 해결 과정
1. 공식 아카이브(`docs.flutter.dev/install/archive`)에서 최신 stable zip 다운로드.
2. 한글·공백·`Program Files`를 피해 **`C:\src\flutter`** 에 압축 해제.
   - `C:\src\flutter\bin\flutter.bat` 존재로 정상 해제 확인.
3. 시스템 환경변수 `Path`에 **`C:\src\flutter\bin`** 추가.
4. 터미널을 새로 열고 `flutter --version` 으로 인식 확인.

## 결과 / 배운 점
- `flutter --version`이 정상 출력되며 설치 완료.
- 개발 도구는 **경로에 한글·공백을 넣지 않는다**는 원칙을 체득. 이후 프로젝트도 `C:\projects\muldeun`로 통일.
