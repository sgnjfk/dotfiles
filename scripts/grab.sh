#!/usr/bin/env bash
set -uo pipefail

DEFAULT_N=10
DEFAULT_SRC='P:\Downloads'
DEFAULT_DST="$PWD"

prompt() {
    local label="$1" default="$2"
    printf '  %s \e[2m[%s]\e[0m: ' "$label" "$default" >&2
    IFS= read -r val
    echo "${val:-$default}"
}

human_size() {
    local b=$1
    if (( b >= 1073741824 )); then printf '%.1fG' "$(bc -l <<< "$b/1073741824")"
    elif (( b >= 1048576 )); then printf '%.1fM' "$(bc -l <<< "$b/1048576")"
    elif (( b >= 1024 )); then printf '%.1fK' "$(bc -l <<< "$b/1024")"
    else printf '%dB' "$b"
    fi
}

# --- Prompt ---
printf '\n' >&2
n=$(prompt "Recent files (n)" "$DEFAULT_N")
src=$(prompt "Source (S)" "$DEFAULT_SRC")
dst=$(prompt "Dest (D)" "$DEFAULT_DST")
printf '\n' >&2

wsl_src=$(wslpath "$src" 2>/dev/null || echo "$src")
[[ ! -d "$wsl_src" ]] && { printf 'error: %s not found\n' "$src" >&2; exit 1; }
[[ ! -d "$dst" ]] && { printf 'error: %s not found\n' "$dst" >&2; exit 1; }

# --- Load files ---
mapfile -t entries < <(
    find "$wsl_src" -maxdepth 1 -type f -printf '%T@\t%s\t%f\n' \
    | sort -rn | head -n "$n"
)

[[ ${#entries[@]} -eq 0 ]] && { echo "No files found." >&2; exit 0; }

files=() sizes=()
for e in "${entries[@]}"; do
    IFS=$'\t' read -r _ sz name <<< "$e"
    sizes+=("$sz")
    files+=("$name")
done

# --- TUI picker ---
cursor=0
total=${#files[@]}
declare -A sel

hide_cursor() { printf '\e[?25l' >&2; }
show_cursor() { printf '\e[?25h' >&2; }
trap show_cursor EXIT

render() {
    # move up to redraw
    printf '\e[%dA' "$((total + 1))" >&2 2>/dev/null || true

    local sel_count=0
    for i in "${!files[@]}"; do [[ -n "${sel[$i]:-}" ]] && ((sel_count++)); done

    printf '\r\e[K  \e[2m%d selected  |  j/k: move  space: select  enter: copy  q: quit\e[0m\n' "$sel_count" >&2

    for i in "${!files[@]}"; do
        local check=" " arrow="  "
        [[ -n "${sel[$i]:-}" ]] && check="✔"
        [[ $i -eq $cursor ]] && arrow="▸ "
        printf '\r\e[K%s[%s] \e[2m%6s\e[0m  %s\n' "$arrow" "$check" "$(human_size "${sizes[$i]}")" "${files[$i]}" >&2
    done
}

# initial draw
hide_cursor
printf '\n' >&2
for _ in "${files[@]}"; do printf '\n' >&2; done
render

while IFS= read -rsn1 key; do
    case "$key" in
        j) (( cursor < total - 1 )) && (( cursor++ )) || true ;;
        k) (( cursor > 0 )) && (( cursor-- )) || true ;;
        ' ')
            if [[ -n "${sel[$cursor]:-}" ]]; then
                unset 'sel[$cursor]'
            else
                sel[$cursor]=1
            fi
            ;;
        '') break ;;
        q) show_cursor; printf 'Cancelled.\n' >&2; exit 0 ;;
    esac
    render
done

show_cursor
printf '\n' >&2

# --- Copy ---
copied=0
for i in $(echo "${!sel[@]}" | tr ' ' '\n' | sort -n); do
    cp "$wsl_src/${files[$i]}" "$dst/"
    printf '  ✔ %s\n' "${files[$i]}" >&2
    ((copied++))
done

if (( copied > 0 )); then
    printf '\nCopied %d file(s) to %s\n' "$copied" "$dst" >&2
else
    printf 'No files selected.\n' >&2
fi
