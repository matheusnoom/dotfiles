#!/usr/bin/env bash
# sync-vscode-profiles.sh
# Sincroniza profiles do VSCode entre ~/.dotfiles e ~/.config/Code/User/profiles/<id>
# Uso: sync-vscode-profiles.sh [backup|apply|list]
#
# Dependências: python3

set -euo pipefail

STORAGE_JSON="$HOME/.config/Code/User/globalStorage/storage.json"
DOTFILES_PROFILES="$HOME/.dotfiles/vscode/.config/Code/User/profiles"
VSCODE_PROFILES="$HOME/.config/Code/User/profiles"

# Arquivos a sincronizar dentro de cada profile
SYNC_FILES=("settings.json" "keybindings.json" "tasks.json")
SYNC_DIRS=("snippets")

# Cores para output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

check_deps() {
    if ! command -v python3 &>/dev/null; then
        log_error "python3 não encontrado. Instale com: sudo pacman -S python"
        exit 1
    fi
    if [[ ! -f "$STORAGE_JSON" ]]; then
        log_error "storage.json não encontrado em: $STORAGE_JSON"
        exit 1
    fi
}

# Retorna o ID do profile dado seu nome
get_profile_id() {
    local name="$1"
    python3 - "$STORAGE_JSON" "$name" <<'PYEOF'
import sys, json
with open(sys.argv[1]) as f:
    data = json.load(f)
name = sys.argv[2]
for p in data.get("userDataProfiles", []):
    if p.get("name") == name:
        print(p.get("location") or p.get("id", ""))
        break
PYEOF
}

# Conta profiles no storage.json
_count_profiles() {
    python3 - "$STORAGE_JSON" <<'PYEOF'
import sys, json
with open(sys.argv[1]) as f:
    data = json.load(f)
print(len(data.get("userDataProfiles", [])))
PYEOF
}

# Itera profiles: imprime "nome\tid" por linha
_iter_profiles() {
    python3 - "$STORAGE_JSON" <<'PYEOF'
import sys, json
with open(sys.argv[1]) as f:
    data = json.load(f)
for p in data.get("userDataProfiles", []):
    name = p.get("name", "")
    loc  = p.get("location") or p.get("id", "")
    print(f"{name}\t{loc}")
PYEOF
}

# Lista todos os profiles do VSCode (nome → id)
cmd_list() {
    check_deps
    echo ""
    log_info "Profiles encontrados no VSCode:"
    echo ""

    local count
    count=$(_count_profiles)

    if [[ "$count" -eq 0 ]]; then
        log_warn "Nenhum profile customizado encontrado (apenas o Default existe)."
        return
    fi

    _iter_profiles | while IFS=$'\t' read -r name id; do
        echo "  $name  →  $id"
    done
    echo ""

    log_info "Profiles versionados no dotfiles:"
    echo ""
    if [[ -d "$DOTFILES_PROFILES" ]]; then
        for dir in "$DOTFILES_PROFILES"/*/; do
            [[ -d "$dir" ]] && echo "  $(basename "$dir")"
        done
    else
        log_warn "Nenhum profile versionado ainda."
    fi
    echo ""
}

# backup: VSCode → dotfiles
cmd_backup() {
    check_deps
    log_info "Modo backup: VSCode → dotfiles"
    echo ""

    local count
    count=$(_count_profiles)

    if [[ "$count" -eq 0 ]]; then
        log_warn "Nenhum profile customizado no VSCode para fazer backup."
        return
    fi

    while IFS=$'\t' read -r name id; do
        [[ -z "$name" || -z "$id" ]] && continue

        local src_dir="$VSCODE_PROFILES/$id"
        local dst_dir="$DOTFILES_PROFILES/$name"

        if [[ ! -d "$src_dir" ]]; then
            log_warn "Profile '$name' (id: $id) não tem pasta em $src_dir — pulando."
            continue
        fi

        mkdir -p "$dst_dir"
        log_info "Backup do profile '$name' (id: $id)..."

        for file in "${SYNC_FILES[@]}"; do
            if [[ -f "$src_dir/$file" ]]; then
                cp "$src_dir/$file" "$dst_dir/$file"
                log_ok "  $file"
            fi
        done

        for dir in "${SYNC_DIRS[@]}"; do
            if [[ -d "$src_dir/$dir" ]]; then
                rm -rf "$dst_dir/$dir"
                cp -r "$src_dir/$dir" "$dst_dir/$dir"
                log_ok "  $dir/"
            fi
        done

    done < <(_iter_profiles)

    echo ""
    log_ok "Backup concluído."
}

# apply: dotfiles → VSCode (via symlinks)
cmd_apply() {
    check_deps
    log_info "Modo apply: dotfiles → VSCode (symlinks)"
    echo ""

    if [[ ! -d "$DOTFILES_PROFILES" ]]; then
        log_warn "Nenhum profile versionado em $DOTFILES_PROFILES"
        return
    fi

    for profile_dir in "$DOTFILES_PROFILES"/*/; do
        [[ -d "$profile_dir" ]] || continue
        local name
        name=$(basename "$profile_dir")

        local id
        id=$(get_profile_id "$name")

        if [[ -z "$id" ]]; then
            log_warn "Profile '$name' não encontrado no VSCode. Crie-o no VSCode primeiro e rode este script novamente."
            continue
        fi

        local dst_dir="$VSCODE_PROFILES/$id"
        if [[ ! -d "$dst_dir" ]]; then
            log_warn "Pasta do profile '$name' (id: $id) não existe: $dst_dir — pulando."
            continue
        fi

        log_info "Aplicando profile '$name' (id: $id)..."

        for file in "${SYNC_FILES[@]}"; do
            local src="${profile_dir%/}/$file"
            local dst="$dst_dir/$file"
            if [[ -f "$src" ]]; then
                [[ -e "$dst" || -L "$dst" ]] && rm "$dst"
                ln -s "$src" "$dst"
                log_ok "  symlink: $dst → $src"
            fi
        done

        for dir in "${SYNC_DIRS[@]}"; do
            local src="${profile_dir%/}/$dir"
            local dst="$dst_dir/$dir"
            if [[ -d "$src" ]]; then
                [[ -e "$dst" || -L "$dst" ]] && rm -rf "$dst"
                ln -s "$src" "$dst"
                log_ok "  symlink: $dst → $src"
            fi
        done

    done

    echo ""
    log_ok "Apply concluído."
}

usage() {
    echo "Uso: $(basename "$0") <comando>"
    echo ""
    echo "Comandos:"
    echo "  backup  — Copia settings dos profiles do VSCode para o dotfiles"
    echo "  apply   — Cria symlinks do dotfiles para as pastas de profile do VSCode"
    echo "  list    — Lista profiles do VSCode e do dotfiles (diagnóstico)"
    echo ""
    echo "Dependências: python3"
    echo ""
}

case "${1:-}" in
    backup) cmd_backup ;;
    apply)  cmd_apply  ;;
    list)   cmd_list   ;;
    *)      usage; exit 1 ;;
esac
