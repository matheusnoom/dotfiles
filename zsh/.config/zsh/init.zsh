# Inicializadores de ferramentas externas
# Cada bloco injeta funções/hooks no shell — são opcionais, carregados só se instalados.
# Para adicionar uma nova ferramenta: copie o padrão abaixo.

# Starship — substitui o $PROMPT
if command -v starship >/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  eval "$(starship init zsh)"
fi

# Pyenv — gerenciador de versões do Python
if command -v pyenv >/dev/null; then
  eval "$(pyenv init -)"
fi

# SDKMAN — gerenciador de versões Java/Kotlin/Gradle/etc.
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
