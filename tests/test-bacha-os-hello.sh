#!/usr/bin/env bash
# Deterministic mock test for BacHa OS Hello; no real block device is accessed.
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/home" "$TEST_DIR/state"

cat > "$TEST_DIR/bin/lsblk" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  *"PATH,TYPE,FSTYPE"*)
    case "${LSBLK_MODE:-mixed}" in
      none) ;;
      *) printf '%s\n' '/dev/sda2 part ntfs' '/dev/sdb1 part ntfs' ;;
    esac
    ;;
esac
EOF

cat > "$TEST_DIR/bin/findmnt" <<'EOF'
#!/usr/bin/env bash
if [[ "${LSBLK_MODE:-mixed}" == "status" && "$*" == *"/dev/sda2"* ]]; then
  printf '%s\n' '/mnt/ocung1'
fi
EOF

cat > "$TEST_DIR/bin/pkexec" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  *bacha-os-ntfs-mount)
    if [[ "${LSBLK_MODE:-mixed}" == "none" ]]; then
      printf '%s\n' 'NONE|Không tìm thấy phân vùng NTFS.'
    else
      printf '%s\n' 'MOUNTED|/dev/sda2|/mnt/ocung1|rw'
      printf '%s\n' 'READONLY|/dev/sdb1|/mnt/ocung2|Windows đang hibernate hoặc journal chưa sạch; chỉ đọc.'
    fi
    ;;
  *bacha-os-install-libreoffice)
    printf '%s\n' 'INSTALLED|LibreOffice và gói tiếng Việt đã được cài.'
    ;;
  *) exit 64 ;;
esac
EOF

cat > "$TEST_DIR/bin/zenity" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$ZENITY_CAPTURE"
EOF

chmod +x "$TEST_DIR/bin/lsblk" "$TEST_DIR/bin/findmnt" "$TEST_DIR/bin/pkexec" "$TEST_DIR/bin/zenity"

mkdir -p "$TEST_DIR/helpers"
touch "$TEST_DIR/helpers/bacha-os-ntfs-mount" "$TEST_DIR/helpers/bacha-os-install-libreoffice"
chmod +x "$TEST_DIR/helpers/"*

export PATH="$TEST_DIR/bin:$PATH"
export HOME="$TEST_DIR/home"
export XDG_STATE_HOME="$TEST_DIR/state"
export ZENITY_CAPTURE="$TEST_DIR/zenity.txt"
export BACHA_MOUNT_HELPER="$TEST_DIR/helpers/bacha-os-ntfs-mount"
export BACHA_LIBREOFFICE_HELPER="$TEST_DIR/helpers/bacha-os-install-libreoffice"

LSBLK_MODE=mixed bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-hello" --mount
grep -F 'Đã gắn đọc/ghi' "$ZENITY_CAPTURE"
grep -F '/dev/sda2' "$ZENITY_CAPTURE"
grep -F 'Đã gắn chỉ đọc' "$ZENITY_CAPTURE"
grep -F '/dev/sdb1' "$ZENITY_CAPTURE"
grep -F 'mounted /dev/sda2 /mnt/ocung1 rw' "$XDG_STATE_HOME/bacha-os-hello/mount.log"
grep -F 'mounted /dev/sdb1 /mnt/ocung2 ro' "$XDG_STATE_HOME/bacha-os-hello/mount.log"

: > "$ZENITY_CAPTURE"
LSBLK_MODE=none bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-hello" --mount
grep -F 'Không tìm thấy phân vùng NTFS nào để gắn' "$ZENITY_CAPTURE"

: > "$ZENITY_CAPTURE"
LSBLK_MODE=status bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-hello" --status
grep -F 'Các phân vùng NTFS' "$ZENITY_CAPTURE"
grep -F '/dev/sda2' "$ZENITY_CAPTURE"
grep -F '/mnt/ocung1' "$ZENITY_CAPTURE"

: > "$ZENITY_CAPTURE"
LSBLK_MODE=mixed bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-hello" --install-libreoffice
grep -F 'LibreOffice và gói tiếng Việt đã được cài' "$ZENITY_CAPTURE"

printf '%s\n' 'BacHa OS Hello mock test: OK'
