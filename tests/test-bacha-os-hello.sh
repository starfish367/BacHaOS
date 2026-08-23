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
    printf '%s\n' '/dev/sda2 part ntfs' '/dev/sdb1 part ntfs'
    ;;
  *"MOUNTPOINTS /dev/sda2"*)
    printf '%s\n' ''
    ;;
  *"MOUNTPOINTS /dev/sdb1"*)
    printf '%s\n' ''
    ;;
esac
EOF

cat > "$TEST_DIR/bin/udisksctl" <<'EOF'
#!/usr/bin/env bash
if [[ "$*" == *"/dev/sda2"* ]]; then
  printf '%s\n' 'Mounted /dev/sda2 at /media/test/Data.'
  exit 0
fi
printf '%s\n' 'Error mounting /dev/sdb1: Windows is hibernated.' >&2
exit 1
EOF

cat > "$TEST_DIR/bin/zenity" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$ZENITY_CAPTURE"
EOF

chmod +x "$TEST_DIR/bin/lsblk" "$TEST_DIR/bin/udisksctl" "$TEST_DIR/bin/zenity"

export PATH="$TEST_DIR/bin:$PATH"
export HOME="$TEST_DIR/home"
export XDG_STATE_HOME="$TEST_DIR/state"
export ZENITY_CAPTURE="$TEST_DIR/zenity.txt"

bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-hello" --mount
grep -F 'Đã gắn thành công' "$ZENITY_CAPTURE"
grep -F '/dev/sda2' "$ZENITY_CAPTURE"
grep -F 'Không thể gắn' "$ZENITY_CAPTURE"
grep -F '/dev/sdb1' "$ZENITY_CAPTURE"
grep -F 'mounted /dev/sda2' "$XDG_STATE_HOME/bacha-os-hello/mount.log"
grep -F 'failed /dev/sdb1' "$XDG_STATE_HOME/bacha-os-hello/mount.log"

printf '%s\n' 'BacHa OS Hello mock test: OK'
