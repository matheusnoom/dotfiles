# Extensões do VSCode

Extensões são gerenciadas **manualmente** — não há sync automático.
Cada `extensions.txt` é a fonte de verdade do que deve estar instalado.

## Estrutura

```
vscode/
└── .config/Code/User/
    ├── extensions.txt                          ← Default profile
    ├── settings.json
    └── profiles/
        └── python/
            ├── extensions.txt                  ← extensões exclusivas do profile python
            └── settings.json
```

## Exportar extensões instaladas

```bash
# Default profile
code --list-extensions > ~/.dotfiles/vscode/.config/Code/User/extensions.txt

# Profile específico
code --profile "python" --list-extensions > ~/.dotfiles/vscode/.config/Code/User/profiles/python/extensions.txt
```

> Rode isso sempre que instalar ou remover uma extensão.

## Instalar extensões a partir dos arquivos

```bash
# Default profile
cat ~/.dotfiles/vscode/.config/Code/User/extensions.txt | xargs -L1 code --install-extension

# Profile específico
cat ~/.dotfiles/vscode/.config/Code/User/profiles/python/extensions.txt | xargs -L1 code --profile "python" --install-extension
```

## Fluxo: nova máquina

1. Aplicar stow e o script de profiles (ver [vscode-profiles.md](vscode-profiles.md))
2. Instalar as extensões do Default profile
3. Instalar as extensões de cada profile pelo nome
