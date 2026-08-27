#!/usr/bin/env bash
# Deterministic retry test for the SourceForge public-link verifier.
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT
mkdir -p "$TEST_DIR/output" "$TEST_DIR/bin" "$TEST_DIR/state"

cat > "$TEST_DIR/output/release-mate.env" <<'EOF'
SOURCEFORGE_ISO_URL=https://example.test/mate.iso
EOF
cat > "$TEST_DIR/output/release-cinnamon.env" <<'EOF'
SOURCEFORGE_ISO_URL=https://example.test/cinnamon.iso
EOF
cat > "$TEST_DIR/bin/curl" <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
url=${!#}
state="${MOCK_STATE}/$(basename "$url").count"
count=0
[[ -f "$state" ]] && count=$(cat "$state")
count=$((count + 1))
printf '%s\n' "$count" > "$state"
if [[ "$url" == *mate.iso ]] && (( count == 1 )); then
  printf '404'
else
  printf '206'
fi
EOF
chmod +x "$TEST_DIR/bin/curl"

output=$(MOCK_STATE="$TEST_DIR/state" \
  BACHA_SOURCEFORGE_CURL="$TEST_DIR/bin/curl" \
  BACHA_SOURCEFORGE_ATTEMPTS=3 \
  BACHA_SOURCEFORGE_DELAY_SECONDS=0 \
  "$ROOT_DIR/scripts/verify-sourceforge-public.sh" "$TEST_DIR/output")

printf '%s\n' "$output" | grep -F 'SourceForge mate verified on attempt 2: HTTP 206'
printf '%s\n' "$output" | grep -F 'SourceForge cinnamon verified on attempt 1: HTTP 206'
printf '%s\n' 'SourceForge public-link verifier test: OK'
