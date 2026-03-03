# dotfiles

Configurações pessoais de terminal gerenciadas com [stow](https://www.gnu.org/software/stow/).
Compatível com **Arch Linux** e **macOS**.

---

## Setup

**1. Clone o repositório**

```bash
git clone https://github.com/SEU_USUARIO/dotfiles.git ~/.dotfiles
```

**2. Instale as dependências e aplique os dotfiles**

```bash
# Arch Linux
bash ~/.dotfiles/bootstrap/arch.sh

# macOS
bash ~/.dotfiles/bootstrap/macos.sh
```

Os scripts instalam os pacotes e rodam `stow` em cada módulo automaticamente.

---

## Módulos (pastas do stow)

| Pasta        | O que configura                                       |
|--------------|-------------------------------------------------------|
| `zsh/`       | .zshenv, .zshrc, env, init, plugins, aliases, colors… |
| `kitty/`     | kitty.conf                                            |
| `starship/`  | starship.toml                                         |
| `tmux/`      | tmux.conf                                             |
| `fastfetch/` | config.jsonc + imagem de logo                         |

> Para adicionar um novo módulo: crie uma pasta com a estrutura espelhando `$HOME` e rode `stow <pasta>`.

---

## Pacotes necessários

A lista abaixo é a fonte de verdade. Os scripts de bootstrap a usam diretamente —
para adicionar um pacote novo, edite o array correspondente em `bootstrap/arch.sh` ou `bootstrap/macos.sh`.

### Infra

| Pacote      | Descrição                                           |
|-------------|-----------------------------------------------------|
| `git`       | controle de versão                                  |
| `vim`       | editor de texto padrão (`$EDITOR`)                  |
| `stow`      | gerencia symlinks dos dotfiles                      |
| `coreutils` | utilitários básicos do sistema (inclui `dircolors`) |

### Shell

| Pacote                    | Descrição                                        |
|---------------------------|--------------------------------------------------|
| `zsh`                     | shell principal                                  |
| `zsh-completions`         | base de completions para zsh                     |
| `zsh-autosuggestions`     | sugestões baseadas no histórico (estilo Fish)    |
| `zsh-syntax-highlighting` | realce de sintaxe dos comandos em tempo real     |

### Terminal

| Pacote  | Descrição                                      |
|---------|------------------------------------------------|
| `kitty` | emulador de terminal com GPU rendering         |

### Ferramentas CLI

| Pacote      | Descrição                                              |
|-------------|--------------------------------------------------------|
| `fd`        | substituto do `find`, sintaxe simples e rápido         |
| `fzf`       | fuzzy finder interativo no terminal                    |
| `bat`       | substituto do `cat`, com realce de sintaxe e paginação |
| `eza`       | substituto do `ls`, com ícones e informações de git    |
| `starship`  | prompt customizado e leve, cross-shell                 |
| `fastfetch` | exibição de informações do sistema no terminal         |

### Fontes

| Pacote (Arch)               | Cask (macOS)                      | Descrição                                     |
|-----------------------------|-----------------------------------|-----------------------------------------------|
| `ttf-jetbrains-mono`        | `font-jetbrains-mono`             | fonte de programação legível e bonita          |
| `ttf-jetbrains-mono-nerd`   | `font-jetbrains-mono-nerd-font`   | mesma fonte com ícones Nerd (terminal/editor)  |

### Opcionais (carregados automaticamente se instalados)

| Pacote    | Descrição                                              |
|-----------|--------------------------------------------------------|
| `pyenv`   | gerenciador de versões do Python                       |
| `sdkman`  | gerenciador de versões Java/Kotlin/Gradle/etc.         |

---

## Testar depois

| Pacote    | Descrição                                           |
|-----------|-----------------------------------------------------|
| `ripgrep` | substitui `grep -R`, mais rápido e moderno          |
| `zoxide`  | substitui `cd` de forma inteligente                 |
| `delta`   | melhora visual do `git diff`                        |
