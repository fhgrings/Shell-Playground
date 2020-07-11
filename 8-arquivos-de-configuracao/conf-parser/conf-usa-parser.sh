#!/usr/bin/env bash
#
# conf-usa-parser.sh - Programa de exemplo de uso do conf-parser.sh
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá utilizar o conf-parser.sh para realizar a leitura do
#  arquivo de configurações de forma generica.
#
#  Exemplos:
#      $ ./conf-usa-parser.sh
#      Neste exemplo o script buscará as configurações dos default.conf.
#
#      $ ./conf-parser.sh vpn.conf
#      Neste exemplo o script buscará as configurações dos vpn.conf.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 10/10/2020, Felipe:
#       - Início do programa
#       - Conta com a funcionalidade X
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
MENSAGEM="Mensagem padrao"
USAR_MAIUSCULAS=
USAR_CORES=
VERMELHO="\033[31;1m"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #
[ ! -e "conf-parser.sh" ] && echo "ERROR. Parser não encontrado" && exit 1
# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
eval $(./conf-parser.sh $1)

echo $CONF_USAR_CORES
echo $CONF_USAR_MAIUSCULAS

[ "$(echo $CONF_USAR_MAIUSCULAS)" = "1" ] && USAR_MAIUSCULAS="1"
[ "$(echo $CONF_USAR_CORES)" = "1" ] && USAR_CORES="1"

[ "$USAR_CORES" = "1" ] && MENSAGEM="$(echo -e $MENSAGEM | tr [a-z] [A-Z])"
[ "$USAR_MAIUSCULAS" = "1" ] && MENSAGEM="$(echo -e ${VERMELHO}$MENSAGEM)"

echo -e "$MENSAGEM"

# ------------------------------------------------------------------------ #
