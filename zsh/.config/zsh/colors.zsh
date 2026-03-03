# cores do zsh derivadas do pywal (origem: ~/.cache/wal/colors.sh)
# mapeamento semântico: qual slot cobre qual papel visual
# override de um slot: sobrescreva a variável após o source
#   _ZSH_ERROR="fg=#ff0000,bold"
#   ZSH_HIGHLIGHT_STYLES[unknown-token]=$_ZSH_ERROR
if [[ ! -f ~/.cache/wal/colors.sh ]]; then return; fi
source ~/.cache/wal/colors.sh

# mapeamento semântico
#   color4  = azul-cinza   → comandos executáveis
#   color6  = aço azulado  → sudo/env e paths
#   color7  = foreground   → texto base
#   color8  = cinza médio  → elementos dim (aliases, operadores, comentários)
#   color5  = mauve        → assigns
#   color1  = vinho        → erro
_ZSH_ACCENT="fg=${color4},bold"            # comandos reconhecidos — cor distinta do texto
_ZSH_NORMAL="fg=${color7}"                 # built-ins, strings, funções, palavras-chave
_ZSH_SUBTLE="fg=${color8}"                 # aliases
_ZSH_MUTED="fg=${color8}"                  # operadores, redirects, globbing, histórico
_ZSH_DIM="fg=${color5}"                    # assigns (FOO=bar)
_ZSH_GHOST="fg=${color8}"                  # comentários, path prefix
_ZSH_PATH="fg=${color6},underline"         # caminho válido: sublinhado + cor distinta
_ZSH_ERROR="fg=${color1},bold"             # token desconhecido / typo

# zsh syntax highlighting
ZSH_HIGHLIGHT_STYLES[command]=$_ZSH_ACCENT
ZSH_HIGHLIGHT_STYLES[builtin]=$_ZSH_NORMAL
ZSH_HIGHLIGHT_STYLES[function]=$_ZSH_NORMAL
ZSH_HIGHLIGHT_STYLES[alias]=$_ZSH_SUBTLE
ZSH_HIGHLIGHT_STYLES[precommand]="fg=${color2},bold"  # sudo, env, nice...
ZSH_HIGHLIGHT_STYLES[reserved-word]=$_ZSH_NORMAL
ZSH_HIGHLIGHT_STYLES[default]=$_ZSH_MUTED             # flags e args (-S, --needed...)
ZSH_HIGHLIGHT_STYLES[path]=$_ZSH_PATH
ZSH_HIGHLIGHT_STYLES[path_prefix]=$_ZSH_GHOST
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=$_ZSH_NORMAL
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=$_ZSH_NORMAL
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=$_ZSH_SUBTLE
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=$_ZSH_MUTED
ZSH_HIGHLIGHT_STYLES[assign]=$_ZSH_DIM
ZSH_HIGHLIGHT_STYLES[redirection]=$_ZSH_MUTED
ZSH_HIGHLIGHT_STYLES[named-fd]=$_ZSH_MUTED
ZSH_HIGHLIGHT_STYLES[globbing]=$_ZSH_MUTED
ZSH_HIGHLIGHT_STYLES[history-expansion]=$_ZSH_MUTED
ZSH_HIGHLIGHT_STYLES[comment]=$_ZSH_GHOST
ZSH_HIGHLIGHT_STYLES[unknown-token]=$_ZSH_ERROR

# zsh autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${color8}"

# zsh completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:descriptions' format "%F{${color8}}%d%f"
zstyle ':completion:*:warnings'     format "%F{${color8}}nenhuma correspondência%f"

# LS_COLORS / EZA_COLORS — true color (38;2;R;G;B)
# para mudar o mapeamento de categorias, edite o bloco _C= abaixo
_rgb() { local h="${1#\#}"; printf "38;2;%d;%d;%d" 0x${h:0:2} 0x${h:2:2} 0x${h:4:2}; }

_C="\
di=1;$(_rgb $color4):\
ln=4;$(_rgb $color6):\
ex=1;$(_rgb $color2):\
or=1;$(_rgb $color1):\
mi=1;$(_rgb $color1):\
so=$(_rgb $color5):\
pi=$(_rgb $color8):\
bd=1;$(_rgb $color8):\
cd=1;$(_rgb $color8):\
*.tar=$(_rgb $color3):*.tgz=$(_rgb $color3):*.gz=$(_rgb $color3):\
*.zip=$(_rgb $color3):*.7z=$(_rgb $color3):*.rar=$(_rgb $color3):\
*.bz2=$(_rgb $color3):*.xz=$(_rgb $color3):*.zst=$(_rgb $color3):\
*.jpg=$(_rgb $color6):*.jpeg=$(_rgb $color6):*.png=$(_rgb $color6):\
*.gif=$(_rgb $color6):*.webp=$(_rgb $color6):*.svg=$(_rgb $color6):\
*.mp4=$(_rgb $color6):*.mkv=$(_rgb $color6):*.avi=$(_rgb $color6):\
*.mp3=$(_rgb $color5):*.flac=$(_rgb $color5):*.ogg=$(_rgb $color5):\
*.wav=$(_rgb $color5):*.opus=$(_rgb $color5):\
*.bak=$(_rgb $color8):*.tmp=$(_rgb $color8):*.swp=$(_rgb $color8):\
*.log=$(_rgb $color8):*.old=$(_rgb $color8):\
*.toml=$(_rgb $color5):*.yaml=$(_rgb $color5):*.yml=$(_rgb $color5):\
*.json=$(_rgb $color5):*.conf=$(_rgb $color5):*.env=$(_rgb $color5):\
Makefile=1;$(_rgb $color5):Dockerfile=1;$(_rgb $color5)"

export LS_COLORS="${_C}:su=30;41:ow=30;42:st=30;44:"
export EZA_COLORS="${_C}"
unset _C
unfunction _rgb