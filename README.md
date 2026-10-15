# Starlight Odyssey: Hajun's Quest

하준이 주인공인 영어 우주 모험 게임 (11–12세). RPG와 슈팅을 섞고, 미션 중 미국 6–8학년 수학·과학·영어·미국사·시민/사회·세계사 문제를 풀어 보상을 얻습니다.

## 바로 해 보기

- **파일로 열기:** `www/index.html` 을 브라우저로 엽니다.
- **Linux Mint에 설치:** 이 폴더에서 실행하면 메뉴 > 게임에 아이콘이 생깁니다.

  ```bash
  sudo apt install chromium   # 주소창 없는 앱 창으로 열기 (선택)
  bash install-linux.sh       # 지울 때: bash uninstall-linux.sh
  ```

- **휴대폰에서 같은 와이파이로 테스트:** `python3 -m http.server 8000 -d www` 후 휴대폰에서 `http://<PC IP>:8000`

## 게임 구성 (요약)

- **장르:** 은하 지도 RPG(갈림길 미션 · 정거장 · 승무원 · 레벨/스킬) + 세로 슈팅(자동 사격 · 보스)
- **7개 섹터:** Euler Belt(수학) → Helix Nebula(과학) → Lexicon Station(영어) → Liberty Drift(미국사) → Agora Rings(시민·지리·경제) → Chronos Expanse(세계사) → Null Core(전 과목). 섹터마다 중점 과목 50%, 나머지는 섞어서 출제.
- **문제 → 보상 규칙**
  - Data Cache 정답: 강화 카드 3장 중 선택 (어려운 문제일수록 Rare/Epic 확률 ↑, 빠른 정답 XP ×1.5)
  - 오답: 작은 위로 카드 1장 + 해설 + 몇 문제 뒤 복습 출제 → 복습 정답 시 Redemption 보너스(Rare 이상 보장)
  - 힌트 사용: 보기 2개 제거, 카드 2장 중 선택 / 승무원은 자기 과목에서 미션당 1회 무료 힌트
  - 3연속 정답 Overdrive 충전, 정답 누적·보스·엘리트로 Star Codex(48장) 수집
  - 보스 Encryption Lock: 정답이면 방어막 파괴 + 추가 피해, 오답이면 6초 Overclock 버티기
  - 격추 시 Emergency Reboot 문제: 정답이면 50% 회복 부활
- **난이도 자동 조절:** 과목별 Elo 레이팅. 정답률 약 65%가 되도록 출제, 약 1/6은 도전 문제.
- **문제 은행:** 6과목 직접 작성 문제 731개 + 수학 생성기 51종(무한 변형). 모든 문제에 해설 포함.
- **시간 관리:** 부모가 정하는 근무 시간(20/30/45/60분). 80%에서 예고, 미션이 끝난 뒤 종료 화면(요약 · 다음 이야기 예고 · 1시간 이상 쉬면 Rested 보너스 XP ×1.5). 매일 첫 접속 Daily Supply Drop. 모든 노드 후 자동 저장.
- **부모 리포트:** 과목별 레이팅·학년 추정·정답률, 최근 7일 문제 수, 약한 주제, 최근 오답과 해설.
- **조작:** 화면 드래그 또는 방향키/WASD 이동, 자동 사격. Space/B = Nova Burst, E = Overdrive, 1–4 = 보기 선택, H = 힌트, P/Esc = 일시정지.

## GitHub에 올리기 (Linux Mint)

```bash
sudo apt install git gh
gh auth login -s workflow
cd starlight-odyssey
git init -b main && git add . && git commit -m "Starlight Odyssey: Hajun's Quest 첫 버전"
gh repo create starlight-odyssey --public --source=. --push
```

push 하면 자동으로 두 가지가 실행됩니다 (저장소 > Actions 탭에서 확인).

| 작업 | 결과 |
| --- | --- |
| 게임 공개 (`pages.yml`) | `https://<아이디>.github.io/starlight-odyssey/` — 처음 한 번은 Settings > Pages > Source 를 **GitHub Actions** 로 바꾸고 Re-run |
| 안드로이드 테스트 앱 (`android-apk.yml`) | `https://github.com/<아이디>/starlight-odyssey/releases/download/test-build/starlight-odyssey.apk` |

## 앱으로 만들기 (Capacitor 8)

필요: Node.js 22+, Android Studio (안드로이드), Mac + Xcode (iOS)

```bash
npm install
npm run android:add     # android 폴더 생성
npm run sync            # 게임을 고칠 때마다
npm run android:open    # Android Studio에서 실행·서명·AAB 만들기
npm run ios:add && npm run ios:open   # Mac에서만
```

출시 전에 `capacitor.config.json` 의 `appId` 를 내 것으로 바꾸세요 (예: `com.eunsang.starlightodyssey`). 한 번 출시하면 바꿀 수 없어요.
게임 파일을 고친 뒤에는 `www/sw.js` 의 `VERSION` 을 올려야 설치한 사람에게 새 버전이 전달됩니다.
