#!/usr/bin/env bash
# Deterministic test for the privileged ntfs-3g helper; no real block device is accessed.
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/mnt"

cat > "$TEST_DIR/bin/id" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  '-u') printf '%s\n' 0 ;;
  '-g 1000') printf '%s\n' 1000 ;;
  *) /usr/bin/id "$@" ;;
esac
EOF

cat > "$TEST_DIR/bin/lsblk" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' '/dev/sda2 part ntfs' '/dev/sdb1 part ntfs'
EOF

cat > "$TEST_DIR/bin/findmnt" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

cat > "$TEST_DIR/bin/mountpoint" <<'EOF'
#!/usr/bin/env bash
target=${!#}
[[ -f "$target/.mounted" ]]
EOF

cat > "$TEST_DIR/bin/ntfs-3g" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$NTFS3G_CAPTURE"
if [[ "$*" == *'/dev/sdb1'* ]] && [[ "$*" != *'ro,'* ]]; then
  printf '%s\n' 'Windows is hibernated' >&2
  exit 1
fi
target=${!#}
touch "$target/.mounted"
exit 0
EOF

chmod +x "$TEST_DIR/bin/"*
export PATH="$TEST_DIR/bin:$PATH"
export PKEXEC_UID=1000
export BACHA_MOUNT_ROOT="$TEST_DIR/mnt"
export NTFS3G_CAPTURE="$TEST_DIR/ntfs3g.txt"

output=$(bash "$ROOT_DIR/assets/bacha-os-hello/bacha-os-ntfs-mount")
printf '%s\n' "$output" | grep -F "MOUNTED|/dev/sda2|${TEST_DIR}/mnt/ocung1|rw"
printf '%s\n' "$output" | grep -F "READONLY|/dev/sdb1|${TEST_DIR}/mnt/ocung2"
grep -F 'uid=1000,gid=1000,umask=022,windows_names,noatime,norecover /dev/sda2' "$NTFS3G_CAPTURE"
grep -F 'ro,uid=1000,gid=1000,umask=022,windows_names,noatime,norecover /dev/sdb1' "$NTFS3G_CAPTURE"
if grep -Fq 'remove_hiberfile' "$NTFS3G_CAPTURE"; then
  printf '%s\n' 'Helper không được phép xóa Windows hiberfile.' >&2
  exit 1
fi

printf '%s\n' 'BacHa OS ntfs-3g helper test: OK'
