#!/usr/bin/env bash
#
# debug-niveis.sh - Executa um programa em dois niveis de debug
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá executar a soma dos valores 1 a 25. O programa contem
#  a opção de debug por passagem de parametros na sua chamada .
#
#  Exemplos:
#      $ ./debug-niveis.sh -d 2
#      Neste exemplo será executado com a opção nivel 2 de debug, a mais completa.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 09/07/2020, Felipe:
#       - Início do programa
#   v1.1 09/07/2020, Felipe:
#       - Adição de coloração no Debug
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
MENSAGEM_USO="
  $(basename $0) - [OPÇÕES]

    -h - Menu de ajuda
    -v - Versão do programa
    -d {nível} - Nível de debug
"

VERSAO="v1.1"

CHAVE_DEBUG=0
NIVEL_DEBUG=0

ROXO="\033[35;1m"
CIANO="\033[36;1m"
# ------------------------------------------------------------------------ #
# ------------------------------- TESTES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
Debugar () {
  [ $1 -le $NIVEL_DEBUG ] && echo -e "${2}Debug $* ----------"
}

Soma () {
  local total=0

  for i in $(seq 1 25); do
    Debugar 1 "$ROXO" "Entrei no for com valor: $i"
    total=$(($total+$i))
    Debugar 2 "$CIANO" "Depois da soma: $total"
  done
}
# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
case "$1" in
  -d) [ $2 ] && NIVEL_DEBUG=$2       ;;
  -h) echo "$MENSAGEM_USO" && exit 1 ;;
   *) Soma                           ;;
esac

 Soma
# ------------------------------------------------------------------------ #
