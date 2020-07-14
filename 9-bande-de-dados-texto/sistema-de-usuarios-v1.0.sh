#!/usr/bin/env bash
#
# sistemas-de-usuairos.sh - Sistema para uso do banco de dados em formato txt
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá cotar o último valor do Bitcoin com base na API xxxx
#
#  Exemplos:
#      $ ./cotarBitcoin.sh -d 1
#      Neste exemplo o script será executado no modo debug nível 1.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 13/10/2020, Felipe:
#       - Início do programa
#       - Conta com a funcionalidade X
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
ARQUIVO_BANCO_DE_DADOS="banco-de-dados.txt"

SEPARADOR=":"

VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

[ ! -e "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de escrita." && exit 1

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
MostraUsuariosNaTela () {
  local id="$(echo $1 | cut -d $SEPARADOR -f 1)"
  local nome="$(echo $1 | cut -d $SEPARADOR -f 2)"
  local email="$(echo $1 | cut -d $SEPARADOR -f 3)"

  echo -e "${VERDE}ID:  ${VERMELHO}$id"
  echo -e "${VERDE}Nome:  ${VERMELHO}$nome"
  echo -e "${VERDE}Email:  ${VERMELHO}$email"
}
ListaUsuarios () {
  while read -r linha
  do
    [ ! "$linha" ] && continue
    [ "$(echo $linha | cut -c1)" = "#" ] && continue
    MostraUsuariosNaTela "$linha"

  done < "$ARQUIVO_BANCO_DE_DADOS"
}

ValidaExistenciaUsuario () {
  grep -i -q "$1$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS"
}

InsereUsuario () {
  local nome="$(echo $1 | cut -d $SEPARADOR -f 2)"

  if ValidaExistenciaUsuario "$nome"
  then
    echo "ERRO. Usuario ja existe"
  else
    echo "$1" >> "$ARQUIVO_BANCO_DE_DADOS"
    echo "Usuário cadastrado com sucesso!"
  fi
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
ListaUsuarios
# ------------------------------------------------------------------------ #
