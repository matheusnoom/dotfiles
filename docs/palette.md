# Onde mudar as cores

Referência rápida: qual arquivo editar para mudar cada coisa visual.

## Fluxo

Nenhum tema é versionado. O cache em `~/.cache/wal/` é gerado localmente e nunca commitado.

```
você roda   wal -i ~/Pictures/wallpaper.png
pywal gera  ~/.cache/wal/colors-kitty.conf   ← kitty lê via include
            ~/.cache/wal/colors.sh           ← zsh sourcia (highlight + ls/eza)
```

Após rodar `wal -i`:

```bash
# recarregar as cores do kitty sem reiniciar
kitty @ set-colors --configured --all ~/.cache/wal/colors-kitty.conf

# recarregar as cores no zsh da sessão atual
source ~/.config/zsh/colors.zsh
```

> Abrir um novo terminal já carrega tudo automaticamente.

---

## O que o pywal cobre (automático)

| app | como | arquivo gerado |
|---|---|---|
| kitty | `include` no `kitty.conf` | `colors-kitty.conf` |
| zsh highlight | `source colors.sh` em `colors.zsh` | `colors.sh` |
| ls / eza | `source colors.sh` em `colors.zsh` | `colors.sh` |

> **tmux:** integração desativada — `source-file` comentado, sem template disponível. Cores do tmux são definidas pelo tema padrão do terminal (herda do kitty via pywal).

## O que você gerencia manualmente

| app | arquivo | o que fica hardcoded |
|---|---|---|
| kitty (overrides) | `kitty/.config/kitty/kitty.conf` | `background`, `active_border_color`, `inactive_border_color` |
| fastfetch | `fastfetch/.config/fastfetch/config.jsonc` | `keyColor` de todos os módulos |
| starship | `starship/.config/starship/starship.toml` | todas as cores (`[fill]`, `[time]`, `[palettes.grey]`, etc.) |
| zsh mapeamento | `zsh/.config/zsh/colors.zsh` | qual `color4`/`color6`/`color8` é acento, erro etc. |

---

## Fonte de verdade

**O pywal extrai as cores do wallpaper.** Não há JSON versionado.
Para consultar a paleta ativa: `cat ~/.cache/wal/colors.sh`

Slots e seus papéis no setup atual:

| slot | papel |
|---|---|
| `background` | fundo do terminal |
| `foreground` / `color7` | texto base |
| `color1` | erro / destaque negativo |
| `color2` | executáveis, `sudo`/`env`/`nice` |
| `color3` | archives (`.tar`, `.gz`, `.zip`...) |
| `color4` | comandos (accent bold), diretórios |
| `color5` | mauve (assigns, áudio, config) |
| `color6` | paths, symlinks, imagens, vídeo |
| `color8` | cinza (aliases, operadores, dim) |

---

## Terminal (kitty)

**Arquivo:** `kitty/.config/kitty/kitty.conf`

A maioria das cores vêm do pywal via `include ~/.cache/wal/colors-kitty.conf`.
Não edite as cores base no `kitty.conf` — rode `wal -i <wallpaper>` e recarregue.

**Overrides hardcoded** (ficam **após** o `include`, sobrescrevem o pywal — edite manualmente):

| propriedade | valor atual | onde mudar |
|---|---|---|
| `background` | `#000000` | linha após o `include` no `kitty.conf` |
| `active_border_color` | `#782634` | idem |
| `inactive_border_color` | `#782634` | idem |

> `#782634` é um vinho escuro que não vem do pywal. Ao trocar o wallpaper, se quiser atualizar a borda, edite manualmente (sugestão: tom escuro de `color1`).

---

## Multiplexador (tmux)

**Status atual: integração pywal DESATIVADA**

O `tmux.conf` tem o `source-file` comentado e nenhum template existe:

```
# source-file -q ~/.cache/wal/colors-tmux.conf   ← COMENTADO
```

O tmux não recebe nenhuma cor do pywal. As cores são as padrão do terminal (que já vêm do kitty via pywal). Para ativar quando quiser:

1. Criar o template `~/.config/wal/templates/colors-tmux.conf` com sintaxe `{color0}`, `{foreground}` etc. e copiar para `~/.dotfiles` se quiser versionar.
2. Descomentar a linha `source-file -q ~/.cache/wal/colors-tmux.conf` no `tmux.conf`.
3. Rodar `wal -i <wallpaper>` para gerar o cache.

Esboço de mapeamento sugerido quando criar o template:

| o que cobrir | slot sugerido |
|---|---|
| fundo da status bar | `{color0}` |
| texto dim da status bar | `{color8}` |
| janela ativa | `{foreground}` bold |
| borda ativa | `{color8}` |
| erro (mensagem) | `{color1}` |

---

## Prompt (starship)

**Arquivo:** `starship/.config/starship/starship.toml` — cores hardcoded

Pywal não tem suporte nativo a starship. Cores gerenciadas manualmente.

| o que mudar | chave | valor atual |
|---|---|---|
| símbolo de sucesso | `[character] success_symbol` | `bold green` → resolve para `#777777` via paleta |
| símbolo de erro | `[character] error_symbol` | `bold red` → resolve para `#777777` via paleta |
| linha separadora | `[fill] style` | `#222222` (quase preto, independente da paleta) |
| hora | `[time] style` | `#444444` (cinza escuro) |
| pacote/versão | `[package] style` | `#777777` |
| terraform | `[terraform] style` | `bold #777777` |
| paleta inteira | `[palettes.grey]` | `grey = green = red = "#777777"` |

> O prompt é intencionalmente monocromático (tons de cinza neutros). Ao trocar a paleta, decida se mantém mono ou se passa a usar cores da paleta — neste caso, substitua os hexes por nomes definidos em `[palettes.grey]` ou por hexes diretos da nova paleta.

---

## Fastfetch

**Arquivo:** `fastfetch/.config/fastfetch/config.jsonc` — cores hardcoded

Pywal não tem suporte nativo a fastfetch. Todas as `keyColor` são hexes diretos.

| bloco | propriedade | valor atual | equivalente na paleta |
|---|---|---|---|
| Software — bordas e todas as keys | `keyColor` | `#782634` | vinho escuro (fora da paleta do pywal) |
| Hardware — bordas e todas as keys | `keyColor` | `#6E728F` | `color4` (azul-cinza) |

> `#782634` é um vinho escuro **fora da paleta do pywal**. Ao trocar o wallpaper, escolha um novo hex manualmente (sugestão: tom escuro de `color1`) e substitua **todas** as ocorrências de `#782634` no arquivo. O mesmo vale para `#6E728F` → substitua pelo novo valor de `color4`.

---

## Shell (zsh — syntax highlight)

**Arquivo:** `zsh/.config/zsh/colors.zsh`

As cores vêm do pywal via `source ~/.cache/wal/colors.sh`.
O que você gerencia aqui é o **mapeamento semântico**: qual slot (`color4`, `color6`...)
cobre qual papel visual.

| variável | slot | o que afeta |
|---|---|---|
| `_ZSH_ACCENT` | `color4` bold | comandos (`git`, `pacman`...) |
| `_ZSH_NORMAL` | `color7` | built-ins, strings, funções |
| `_ZSH_PATH` | `color6` underline | caminhos que existem |
| `_ZSH_ERROR` | `color1` bold | token desconhecido / typo |
| `precommand` | `color6` bold | `sudo`, `env`... |
| muted / dim / ghost | `color8` | aliases, operadores, comentários |

---

## Cores do `ls` / `eza`

**Arquivo:** `zsh/.config/zsh/colors.zsh` — bloco `LS_COLORS / EZA_COLORS`

Gerado em true color (`38;2;R;G;B`) a partir de `~/.cache/wal/colors.sh`. Sem `dircolors`.
Para mudar qual slot cobre qual categoria, edite o bloco `_C=` em `colors.zsh`.

| categoria | slot |
|---|---|
| diretório | `color4` bold |
| symlink | `color6` underline |
| executável | `color2` bold |
| `.tar`, `.gz`, `.zip`... | `color3` |
| imagens, vídeo | `color6` |
| áudio | `color5` |
| `.bak`, `.tmp`, `.log`... | `color8` |
| `.toml`, `.yml`, `.json`... | `color5` |

---

## Fonte

**Arquivo:** `kitty/.config/kitty/kitty.conf` — linha `font_family` e `font_size`
