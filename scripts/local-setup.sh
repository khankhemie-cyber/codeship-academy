#!/usr/bin/env bash
# Back-compat alias — use scripts/setup-all.sh
exec "$(dirname "$0")/setup-all.sh" "$@"
