#!/usr/bin/env bash
# Apply all SQL files to Supabase in the correct order.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -f .env.local ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env.local
  set +a
fi

SQL_FILES=(
  schema.sql
  curriculum.sql
  curriculum-explorers.sql
  curriculum-explorers-projects.sql
  curriculum-builders.sql
  curriculum-builders-quizzes.sql
  curriculum-builders-quizzes-complete.sql
  curriculum-builders-projects.sql
  curriculum-developers.sql
  curriculum-developers-quizzes.sql
  classes.sql
  school-portal.sql
  patch.sql
)

USE_PSQL=0
USE_LINKED=0

if [[ -n "${DATABASE_URL:-}" ]]; then
  USE_PSQL=1
elif [[ -f supabase/.temp/project-ref ]] || [[ -f .supabase/linked_project ]]; then
  USE_LINKED=1
else
  echo "No database connection configured."
  echo "  Option A: set DATABASE_URL in .env.local"
  echo "  Option B: npx supabase login && bash scripts/link-supabase.sh <project-ref>"
  exit 1
fi

run_file() {
  local file="$1"
  local path="supabase/$file"
  if [[ ! -f "$path" ]]; then
    echo "Skip missing $path"
    return 0
  fi
  echo "==> $file"
  if [[ "$USE_PSQL" -eq 1 ]]; then
    psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$path" -q
  else
    npx supabase db query -f "$path" --linked
  fi
}

echo "Applying ${#SQL_FILES[@]} SQL files to database..."
for f in "${SQL_FILES[@]}"; do
  run_file "$f"
done
echo "Database setup complete."
