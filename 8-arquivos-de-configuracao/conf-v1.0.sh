#!/usr/bin/env bash

# ------------------------------- VARIÁVEIS ----------------------------------------- #
ARQUIVO_DE_CONFIGURACAO="estudos.conf"
USAR_CORES=
USAR_MAIUSCULAS=
MENSAGEM="Mensagem padrão"

VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #
[ ! -r "$ARQUIVO_DE_CONFIGURACAO" ] && echo "Acesso negado a leitura do arquivo de configurações" && exit 1

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

DefinirParametros () {
  local parametro="$(echo $1 | cut -d = -f 1)"
  local valor="$(echo $1 | cut -d = -f 2)"

  case "$parametro" in
    USAR_CORES) USAR_CORES="$valor"     ;;
    USAR_MAIUSCULAS) USAR_MAIUSCULAS="$valor" ;;
  esac
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #

while read -r linha
do
  [ "$(echo $linha | cut -c1)" = "#" ] && continue
  [ ! "$linha" ] && continue
  DefinirParametros "$linha"
done < estudos.conf

echo $USAR_CORES
echo $USAR_MAIUSCULA
# ------------------------------------------------------------------------ #
