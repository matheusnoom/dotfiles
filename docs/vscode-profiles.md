# Versionamento de Profiles do VSCode

## O problema

O VSCode gera IDs aleatórios para cada profile criado (ex: `72307efe`). As configurações ficam em:

```
~/.config/Code/User/profiles/<id_gerado>/settings.json
```

Isso torna o versionamento direto com stow inviável — o ID muda entre máquinas e não há como prever o valor.

## A solução

O arquivo `~/.config/Code/User/globalStorage/storage.json` contém o mapeamento entre **nome legível** e **ID gerado**:

```json
{
  "userDataProfiles": [
    { "name": "python", "location": "72307efe", ... }
  ]
}
```

A estratégia é versionar os profiles pelo nome (ex: `python/`) e usar um script que lê esse `storage.json` para criar symlinks entre os arquivos versionados e as pastas de ID gerado.

## Dependências

- **python3** — para parsear o `storage.json` (stdlib `json`, sem dependências externas)

## Estrutura no dotfiles

```
vscode/
├── .config/Code/User/
│   ├── settings.json               ← Default profile (gerenciado pelo stow)
│   └── profiles/
│       └── python/                 ← nome legível do profile
│           ├── settings.json
│           └── snippets/
└── scripts/
    └── sync-vscode-profiles.sh
```

Os diretórios dentro de `profiles/` usam o **nome do profile**, não o ID.

## Script: sync-vscode-profiles.sh

Localização: `~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh`

### Comandos

```bash
# Diagnóstico: listar profiles do VSCode e do dotfiles
~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh list

# Backup: VSCode → dotfiles (copiar arquivos para o repo)
~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh backup

# Apply: dotfiles → VSCode (criar symlinks)
~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh apply
```

### O que é sincronizado

Por profile, o script sincroniza (quando existirem):

| Arquivo/Pasta    | Descrição                      |
|------------------|--------------------------------|
| `settings.json`  | Configurações do profile       |
| `keybindings.json` | Atalhos de teclado           |
| `tasks.json`     | Tasks do workspace             |
| `snippets/`      | Snippets de código             |

### Como funciona o apply

Para cada pasta em `profiles/<Nome>/`, o script:

1. Lê o `storage.json` para descobrir o ID correspondente ao nome
2. Remove o arquivo/pasta existente em `~/.config/Code/User/profiles/<id>/`
3. Cria um symlink apontando para o arquivo no dotfiles

O resultado é que o VSCode lê diretamente os arquivos versionados.

## Integração com stow

O stow gerencia **apenas o Default profile** (`settings.json` na raiz de `User/`).
Os profiles com ID gerado são gerenciados **exclusivamente pelo script acima**.

Após rodar `stow vscode`, é necessário também rodar:

```bash
~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh apply
```

## Pre-commit hook

O arquivo `.git/hooks/pre-commit` roda o `backup` automaticamente antes de cada commit, garantindo que os profiles estão sempre atualizados no repositório.

## Fluxo: nova máquina

```bash
# 1. Clonar o repo e aplicar os módulos com stow
cd ~/.dotfiles && stow vscode

# 2. Abrir o VSCode e criar os profiles pelo nome exato (ex: "python")
#    O VSCode vai gerar um novo ID para cada um

# 3. Aplicar os profiles versionados via symlinks
~/.dotfiles/vscode/scripts/sync-vscode-profiles.sh apply
```

> Se um profile do dotfiles não existir no VSCode ainda, o script avisa e pula — ele nunca quebra silenciosamente.

## Fluxo: atualizar settings no dia a dia

As alterações feitas no VSCode são gravadas direto nos arquivos versionados (via symlink), então basta commitar normalmente. O pre-commit hook garante o backup antes do commit caso algo tenha sido salvo sem symlink.

## Profiles versionados

| Nome    | Finalidade                          |
|---------|-------------------------------------|
| python  | Desenvolvimento Python (ruff, pyright, formatadores) |
