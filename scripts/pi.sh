#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

DOCKER="sudo docker"

# Container name mapping (short → full)
declare -A CONTAINERS=(
  [oc]="openclaw"
  [lb]="codex-lb"
  [n8n]="n8n"
  [owui]="open-webui"
  [adg]="big-bear-adguard-home-host"
  [npm]="nginxproxymanager"
  [wg]="big-bear-wg-easy-v15"
  [uk]="uptime-kuma"
  [hp]="homepage"
  [pdf]="big-bear-stirling-pdf"
  [ppl]="paperless-ngx"
  [uma]="umami"
  [ab]="actual-budget"
  [pt]="big-bear-portainer"
)

resolve() {
  echo "${CONTAINERS[$1]:-$1}"
}

usage() {
  cat <<'EOF'
pi — Pi home server CLI

USAGE:
  pi <service> <command> [args...]
  pi <global-command>

SERVICES (short names):
  oc   openclaw          lb   codex-lb
  n8n  n8n               owui open-webui
  adg  adguard-home      npm  nginx-proxy-manager
  wg   wireguard         uk   uptime-kuma
  hp   homepage          pdf  stirling-pdf
  ppl  paperless-ngx     uma  umami
  ab   actual-budget     pt   portainer

SERVICE COMMANDS:
  logs [-f] [N]    View logs (default: follow, last 50 lines)
  restart          Restart container
  stop / start     Stop or start container
  sh [cmd...]      Shell into container (or run a command)
  exec <cmd...>    Run command in container
  info             Show container details

OPENCLAW SHORTCUTS:
  pi oc config     Edit openclaw config in nvim
  pi oc tui        Launch OpenClaw TUI
  pi oc login      WhatsApp channel login
  pi oc backup     Backup openclaw data

GLOBAL COMMANDS:
  pi status        Show all containers status
  pi restart-all   Restart all containers
  pi disk          Show disk usage
  pi backup        Run system backup
  pi ports         Show port mappings
EOF
}

# ── Global commands ──

cmd_status() {
  $DOCKER ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | (head -1 && tail -n +2 | sort)
}

cmd_ports() {
  $DOCKER ps --format '{{.Names}}\t{{.Ports}}' | sort | column -t -s $'\t'
}

cmd_disk() {
  echo -e "${CYAN}System:${NC}"
  df -h / /DATA 2>/dev/null | tail -n +2
  echo ""
  echo -e "${CYAN}Docker:${NC}"
  $DOCKER system df
  echo ""
  echo -e "${CYAN}AppData:${NC}"
  sudo du -sh /DATA/AppData/*/ 2>/dev/null | sort -rh | head -10
}

cmd_backup() {
  echo -e "${CYAN}Running system backup...${NC}"
  if [ -f "$HOME/scripts/backup.sh" ]; then
    bash "$HOME/scripts/backup.sh"
  else
    echo -e "${RED}Backup script not found${NC}"
    echo "Expected: ~/scripts/backup.sh"
  fi
}

cmd_restart_all() {
  echo -e "${RED}This will restart ALL containers. Continue? [y/N]${NC}"
  read -r confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
  $DOCKER restart $($DOCKER ps -q)
  echo -e "${GREEN}All containers restarted${NC}"
}

# ── Service commands ──

svc_logs() {
  local container=$(resolve "$1"); shift
  local lines=50
  local follow="-f"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f) follow="-f"; shift ;;
      --no-follow) follow=""; shift ;;
      *) lines="$1"; shift ;;
    esac
  done
  $DOCKER logs $follow --tail "$lines" "$container"
}

svc_restart() { $DOCKER restart "$(resolve "$1")" && echo -e "${GREEN}Restarted $(resolve "$1")${NC}"; }
svc_stop()    { $DOCKER stop "$(resolve "$1")" && echo -e "${GREEN}Stopped $(resolve "$1")${NC}"; }
svc_start()   { $DOCKER start "$(resolve "$1")" && echo -e "${GREEN}Started $(resolve "$1")${NC}"; }

svc_sh() {
  local container=$(resolve "$1"); shift
  if [[ $# -gt 0 ]]; then
    $DOCKER exec -it "$container" "$@"
  else
    # Try common shells
    $DOCKER exec -it "$container" /bin/bash 2>/dev/null \
      || $DOCKER exec -it "$container" /bin/sh
  fi
}

svc_exec() {
  local container=$(resolve "$1"); shift
  $DOCKER exec -it "$container" "$@"
}

svc_info() {
  local container=$(resolve "$1")
  $DOCKER inspect "$container" --format '
Name:    {{.Name}}
Image:   {{.Config.Image}}
Status:  {{.State.Status}}
Started: {{.State.StartedAt}}
IP:      {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}
Ports:   {{range $p, $conf := .NetworkSettings.Ports}}{{$p}}→{{range $conf}}{{.HostPort}}{{end}} {{end}}
Mounts:  {{range .Mounts}}{{.Source}}→{{.Destination}} {{end}}
'
}

# ── OpenClaw shortcuts ──

oc_config() {
  nvim /DATA/AppData/openclaw/openclaw.json
}

oc_tui() {
  $DOCKER exec -it openclaw openclaw tui
}

oc_login() {
  $DOCKER exec -it openclaw openclaw channels login --channel whatsapp --account default
}

oc_backup() {
  local dest="$HOME/openclaw-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
  echo -e "${CYAN}Backing up OpenClaw to $dest...${NC}"
  sudo tar czf "$dest" -C /DATA/AppData openclaw/
  echo -e "${GREEN}Done: $(du -h "$dest" | cut -f1)${NC}"
}

# ── Main ──

[[ $# -eq 0 ]] && { usage; exit 0; }

case "$1" in
  -h|--help|help) usage ;;
  status)      cmd_status ;;
  ports)       cmd_ports ;;
  disk)        cmd_disk ;;
  backup)      cmd_backup ;;
  restart-all) cmd_restart_all ;;
  *)
    svc="$1"; shift
    [[ $# -eq 0 ]] && { echo -e "${RED}Missing command. Try: pi $svc logs|restart|sh|exec|info${NC}"; exit 1; }
    cmd="$1"; shift

    # OpenClaw special commands
    if [[ "$svc" == "oc" ]]; then
      case "$cmd" in
        config) oc_config; exit ;;
        tui)    oc_tui; exit ;;
        login)  oc_login; exit ;;
        backup) oc_backup; exit ;;
      esac
    fi

    # Generic service commands
    case "$cmd" in
      logs)    svc_logs "$svc" "$@" ;;
      restart) svc_restart "$svc" ;;
      stop)    svc_stop "$svc" ;;
      start)   svc_start "$svc" ;;
      sh)      svc_sh "$svc" "$@" ;;
      exec)    svc_exec "$svc" "$@" ;;
      info)    svc_info "$svc" ;;
      *)       echo -e "${RED}Unknown command: $cmd${NC}"; usage; exit 1 ;;
    esac
    ;;
esac
