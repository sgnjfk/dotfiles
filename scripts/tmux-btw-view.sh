#!/usr/bin/env bash

set -euo pipefail

output_file="${1:-}"
[ -z "$output_file" ] && exit 1
[ ! -f "$output_file" ] && {
  echo "BTW output file not found: $output_file" >&2
  exit 1
}

cleanup() {
  rm -f "$output_file"
}
trap cleanup EXIT

if command -v glow >/dev/null 2>&1; then
  glow -p -w "$(tput cols)" "$output_file"
else
  less +G -R "$output_file"
fi
