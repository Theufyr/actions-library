#!/usr/bin/env bash
set -euo pipefail
HOST="$1"
KEY="$2"
ROOT="$3"
KEEP_ROOT="${4:-true}"
LANG="${5:-en}"
log_invalid="Invalid ROOT"
log_not_found="not found on server, operation aborted."
log_sftp_error_check="SFTP error while checking"
log_sftp_error_dir="SFTP error with directory"
log_keep="directory contents emptied (directory kept)."
log_delete="directory emptied and deleted."
if [[ $ROOT == "fr" ]]; then
  log_invalid="Dossier racine invalide"
  log_not_found="introuvable côté serveur, opération annulée."
  log_sftp_error_check="Erreur SFTP lors de la vérification de"
  log_sftp_error_dir="Erreur SFTP sur le dossier"
  log_keep="contenu vidé (dossier conservé)."
  log_delete="dossier vidé et supprimé."
fi
if [[ -z "${ROOT// /}" || "$ROOT" == "//" || "$ROOT" == "/" || "$ROOT" == "." || "$ROOT" == "/home" || "$ROOT" == "/www" ]]; then
  echo "$log_invalid : '$ROOT'" >&2
  exit 1
fi
parent_dir="$(dirname "$ROOT")"
root_name="$(basename "$ROOT")"
parent_out="$(mktemp)"
parent_err="$(mktemp)"
sftp -i "$KEY" "$HOST" >"$parent_out" 2>"$parent_err" <<EOF
cd "$parent_dir"
ls -la
bye
EOF
root_found=false
while IFS= read -r line; do
  case "$line" in
    d*) ;;
    *) continue ;;
  esac
  entry_name="$(
    awk '
      {
        s=""
        for (i=9; i<=NF; i++)
          s=s (i>9 ? " " : "") $i
        print s
      }
    ' <<< "$line"
  )"
  entry_name="${entry_name%% -> *}"
  if [[ "$entry_name" == "$root_name" ]]; then
    root_found=true
    break
  fi
done < "$parent_out"
if [[ "$root_found" == false ]]; then
  if [[ -s "$parent_out" ]]; then
    echo "'$ROOT' : $log_not_found"
    rm -f "$parent_out" "$parent_err"
    exit 0
  fi
  echo "$log_sftp_error_check '$parent_dir':" >&2
  cat "$parent_err" >&2
  rm -f "$parent_out" "$parent_err"
  exit 1
fi
rm -f "$parent_out" "$parent_err"
COMMANDS_FILE="$(mktemp)"
trap 'rm -f "$COMMANDS_FILE"' EXIT
walk_dir() {
  local dir="$1"
  local out err rc=0
  out="$(mktemp)"
  err="$(mktemp)"
  trap 'rm -f "$out" "$err"' RETURN
  sftp -i "$KEY" "$HOST" >"$out" 2>"$err" <<EOF || rc=$?
cd "$dir"
ls -la
bye
EOF
  if (( rc != 0 )); then
    echo "$log_sftp_error_dir '$dir' (code $rc):" >&2
    cat "$err" >&2
    rm -f "$out" "$err"
    exit 1
  fi
  while IFS= read -r line; do
    case "$line" in
      d*|-*|l*) ;;
      *) continue ;;
    esac
    local type="${line:0:1}"
    local name
    name="$(
      awk '
        {
          s=""
          for (i=9; i<=NF; i++)
            s=s (i>9 ? " " : "") $i
          print s
        }
      ' <<< "$line"
    )"
    name="${name%% -> *}"
    [[ -z "$name" || "$name" == "." || "$name" == ".." ]] && continue
    if [[ "$type" == "d" ]]; then
      local child="$dir/$name"
      walk_dir "$child"
      printf 'rmdir "%s"\n' "$child" >> "$COMMANDS_FILE"
    else
      printf 'rm "%s"\n' "$dir/$name" >> "$COMMANDS_FILE"
    fi
  done < "$out"
}
walk_dir "$ROOT"
{
  cat "$COMMANDS_FILE"
  if [[ "$KEEP_ROOT" != "true" ]]; then
    printf 'rmdir "%s"\n' "$ROOT"
  fi
  echo "bye"
} | sftp -i "$KEY" "$HOST"
if [[ "$KEEP_ROOT" == "true" ]]; then
  echo "'$ROOT' : $log_keep"
else
  echo "'$ROOT' : $log_delete"
fi