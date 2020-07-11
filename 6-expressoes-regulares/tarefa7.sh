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
#   v1.0 09/07/2020, Felipe:
#       - Início do programa
#   v1.1 09/07/2020, Lucas:
#       - Refatorado  conforme o tutorial
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
ARQUIVO_DE_TITULOS="titulos.txt"

VERMELHO="\033[32;1m"
ROXO="\033[35;1m"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #
[ ! -x "$(which lynx)" ] && sudo apt install lynx -y #Lynx instalado?
# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
lynx -source https://www.linuxdescomplicado.com.br/ | grep "jeg_post_title\"><a" | sed "s/<h3.*html\">//;s/<\/a.*//" > titulos.txt

while read -r titulo_lxer
do
  echo -e "${VERMELHO}Titulo: ${ROXO}$titulo_lxer"
done < "$ARQUIVO_DE_TITULOS"
# ------------------------------------------------------------------------ #
