#!/usr/bin/env bash
# Static guard for every v1.0 desktop asset copied by scripts/build.sh.
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

required_assets=(
  assets/bacha-os-hello/bacha-os-hello
  assets/bacha-os-hello/bacha-os-ntfs-mount
  assets/bacha-os-hello/bacha-os-install-libreoffice
  assets/bacha-os-hello/50-bacha-os-hello.rules
  assets/bacha-os-hello/bacha-os-hello.desktop
  assets/bacha-os-hello/bacha-os-hello-autostart.desktop
  assets/bacha-os-hello/bacha-os-hello.svg
  assets/onlyoffice-templates/onlyoffice.desktop
  assets/branding/cinnamon-menu.json
  assets/plymouth/bacha-logo-512.png
)

for asset in "${required_assets[@]}"; do
  [[ -s "${ROOT_DIR}/${asset}" ]] || {
    printf 'Thiếu hoặc rỗng asset bắt buộc: %s\n' "$asset" >&2
    exit 1
  }
done

jq -e '."menu-custom".value == true and ."menu-icon".value == "bacha-os" and ."menu-icon-size".value == 28' \
  "${ROOT_DIR}/assets/branding/cinnamon-menu.json" >/dev/null
grep -Fq "applet-icon='bacha-os'" "${ROOT_DIR}/scripts/customize.sh"
grep -Fq 'bacha-os-install-libreoffice' "${ROOT_DIR}/scripts/build.sh"
grep -Fq 'bacha-os-ntfs-mount' "${ROOT_DIR}/scripts/build.sh"

printf '%s\n' 'BacHa OS build asset guard: OK'
