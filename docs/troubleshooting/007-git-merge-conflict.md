# 007. Git add/add 병합 충돌로 push 거부

## 환경
- Git / GitHub (`Bans-Portfolio/muldeun_app`)
- 로컬 저장소: `C:\projects\muldeun`

## 문제 상황
로컬 프로젝트를 처음 GitHub 원격에 연결한 뒤 push하려 하자 거부됐다.

```
CONFLICT (add/add): Merge conflict in .gitignore
CONFLICT (add/add): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
...
! [rejected]  main -> main (non-fast-forward)
error: failed to push some refs
```

## 원인
- GitHub에서 저장소를 만들 때 자동 생성된 `README.md`, `.gitignore`가 원격에 이미 존재했다.
- 로컬에도 같은 이름의 파일이 있어, `git pull` 시 양쪽 버전이 충돌(`add/add`)했다.
- 충돌이 해결되지 않아 병합 커밋이 끝나지 않았고, 그 상태에서 push가 `non-fast-forward`로 거부됐다.

## 해결 과정
원격의 자동 생성 파일 대신 로컬 버전을 채택하는 방향으로 정리했다.

```bash
git checkout --ours .gitignore README.md   # 로컬(내) 버전 채택
git add .gitignore README.md               # 해결 표시
git commit -m "Merge remote main and resolve conflicts"
git push -u origin main
```

## 결과 / 배운 점
- 정상적으로 push 완료, 로컬과 원격이 연결됨.
- push 거부의 원인이 push 자체가 아니라 **그 앞 단계인 병합 충돌 미해결**이었음을 이해.
- `--ours` / `--theirs`로 충돌 시 어느 버전을 취할지 선택할 수 있음을 학습.
- 이후 다른 환경에서 작업하거나 원격을 수정한 경우, **push 전 `git pull`로 동기화**하면 같은 충돌을 예방할 수 있다.
