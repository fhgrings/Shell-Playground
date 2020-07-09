#!/usr/bin/env bash
#
# busca-titulo-html.sh - Apresenta os titulos dos posts do blog Lxer
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá realizar um CURL no endereço lxer.com, retornar e grava
#  todo o html no endereço .html. Após ira selecionar apenas as divs do titulos
#  separando pela div.class blurb. Em seguida realizará o corte do Span e ficará
#  apenas com o Titulo Original
#
#  Exemplos:
#      $ ./busca-titulo-html.sh
#      Neste exemplo irá buscar os titulos dos posts do blog Lxer.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 03/10/2018, Felipe:
#       - Início do programa
#   v1.1 10/10/2018, Lucas:
#       - Alterado parametro XXXXX
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
INDEX_LXER=""
DIV_TITULOS=""
TITULOS=""

ROXO="\033[35;1m"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
INDEX_LXER="$(curl http://lxer.com )"
[ INDEX_LXER ] || INDEX_LXER="$(cat inde-lxer.html)"

DIV_TITULOS=$(echo "$INDEX_LXER" | grep blurb)

TITULOS=$(echo "$DIV_TITULOS" | sed 's/<div.*line">//;s/<\/span.*//')

for i in "$TITULOS"; do
  echo -e "$ROXO $i"
done
# ------------------------------------------------------------------------ #
