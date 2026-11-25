#!/usr/bin/env bash
# Play 스토어 출시용 서명 키(업로드 키)를 만들고 GitHub Secrets 에 등록합니다.
# Linux Mint 에서 이 저장소 폴더 안에서 한 번만 실행하세요.
#   필요: sudo apt install default-jdk gh   그리고   gh auth login
#
# 키 파일은 저장소 밖(~/android-keys)에 저장됩니다. 절대 GitHub 에 올리지 마세요.
# 이 폴더는 USB나 비밀번호 관리자 등 다른 곳에도 꼭 백업하세요.
set -euo pipefail

APP_NAME="$(node -p "require('./package.json').name" 2>/dev/null || basename "$PWD")"
KEY_DIR="$HOME/android-keys"
KEYSTORE="$KEY_DIR/${APP_NAME}-upload.jks"
INFO="$KEY_DIR/${APP_NAME}-upload.txt"
ALIAS="upload"

command -v keytool >/dev/null || { echo "keytool 이 없습니다: sudo apt install default-jdk"; exit 1; }
command -v gh >/dev/null || { echo "gh 가 없습니다: sudo apt install gh && gh auth login"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "먼저 gh auth login 을 실행하세요."; exit 1; }

mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

if [ -f "$KEYSTORE" ]; then
  echo "이미 키가 있습니다: $KEYSTORE"
  echo "새로 만들지 않고, 저장된 비밀번호로 GitHub Secrets 만 다시 등록합니다."
  PASS="$(grep '^password=' "$INFO" | cut -d= -f2-)"
else
  PASS="$(openssl rand -base64 24 | tr -d '/+=' | head -c 24)"
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" -storetype PKCS12 \
    -alias "$ALIAS" -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$PASS" -keypass "$PASS" \
    -dname "CN=${APP_NAME}, O=bluebut11, C=US"
  printf 'keystore=%s\nalias=%s\npassword=%s\n' "$KEYSTORE" "$ALIAS" "$PASS" > "$INFO"
  chmod 600 "$KEYSTORE" "$INFO"
  echo "키를 만들었습니다: $KEYSTORE"
fi

base64 -w0 "$KEYSTORE" | gh secret set ANDROID_KEYSTORE_BASE64
printf '%s' "$PASS"  | gh secret set ANDROID_KEYSTORE_PASSWORD
printf '%s' "$ALIAS" | gh secret set ANDROID_KEY_ALIAS
printf '%s' "$PASS"  | gh secret set ANDROID_KEY_PASSWORD

echo
echo "GitHub Secrets 등록 완료."
echo "이제 GitHub > Actions > 'Play 스토어 출시용 AAB 만들기' > Run workflow 를 누르세요."
echo "꼭 백업하세요: $KEY_DIR"
