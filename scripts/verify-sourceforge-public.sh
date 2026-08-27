#!/usr/bin/env bash
# Verify public ISO reachability after SourceForge rsync/indexing without downloading whole files.
set -Eeuo pipefail

OUTPUT_DIR=${1:-output}
ATTEMPTS=${BACHA_SOURCEFORGE_ATTEMPTS:-12}
DELAY_SECONDS=${BACHA_SOURCEFORGE_DELAY_SECONDS:-30}
CURL_BIN=${BACHA_SOURCEFORGE_CURL:-curl}

[[ "$ATTEMPTS" =~ ^[1-9][0-9]*$ ]] || {
  printf 'BACHA_SOURCEFORGE_ATTEMPTS must be a positive integer.\n' >&2
  exit 64
}
[[ "$DELAY_SECONDS" =~ ^[0-9]+$ ]] || {
  printf 'BACHA_SOURCEFORGE_DELAY_SECONDS must be a non-negative integer.\n' >&2
  exit 64
}
command -v "$CURL_BIN" >/dev/null 2>&1 || {
  printf 'Missing curl command: %s\n' "$CURL_BIN" >&2
  exit 69
}

verify_sourceforge_iso() {
  local edition="$1"
  local release_env="${OUTPUT_DIR}/release-${edition}.env"
  local attempt http_code

  [[ -s "$release_env" ]] || {
    printf 'Missing release manifest: %s\n' "$release_env" >&2
    return 1
  }
  # Release manifests are generated locally by scripts/build.sh in this workflow.
  # shellcheck disable=SC1090
  source "$release_env"
  [[ -n "${SOURCEFORGE_ISO_URL:-}" ]] || {
    printf 'Missing SourceForge ISO URL in %s\n' "$release_env" >&2
    return 1
  }

  for attempt in $(seq 1 "$ATTEMPTS"); do
    http_code="$("$CURL_BIN" --location --range 0-0 --silent --show-error \
      --output /dev/null --write-out '%{http_code}' --connect-timeout 15 \
      --max-time 45 "$SOURCEFORGE_ISO_URL" || true)"
    if [[ "$http_code" == "206" ]]; then
      printf 'SourceForge %s verified on attempt %s: HTTP %s\n' \
        "$edition" "$attempt" "$http_code"
      return 0
    fi
    printf 'SourceForge %s pending on attempt %s: HTTP %s\n' \
      "$edition" "$attempt" "${http_code:-no-response}" >&2
    if (( attempt < ATTEMPTS )); then sleep "$DELAY_SECONDS"; fi
  done

  printf 'SourceForge link for %s was not publicly reachable in time.\n' \
    "$edition" >&2
  return 1
}

verify_sourceforge_iso mate &
mate_pid=$!
verify_sourceforge_iso cinnamon &
cinnamon_pid=$!
result=0
wait "$mate_pid" || result=1
wait "$cinnamon_pid" || result=1
exit "$result"
