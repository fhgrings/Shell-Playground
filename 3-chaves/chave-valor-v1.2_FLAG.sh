#!/usr/bin/env bash
#
# chave-valor.sh - Lista todos os usuários do SO, podendo ser em ordem alfabetica
# e maiusculo
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá listar todos os usuários do sistema operacional, podendo
#  listar em ordem alfabetica e maiusculo, dependendo dos parametros de entrada.
#
#  Exemplos:
#      $ ./chave-valor.sh -s m
#      Neste exemplo será listado em ordem alfabetica e maiusculo.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 09/07/2020, Felipe:
#       - Início do programa
#       - Apresenta as funcionalidades: Opções, versão e lista de usuários
#   v1.1 09/07/2020, Felipe:
#       - Refatoração para swith case
#       - Adiçao do parametro -s para Ordenaar os usuarios
#   v1.2 09/07/2020, Felipe:
#       - Adição de FLAGS para seleção dos parametros ORDENA e MAIUSCULO
#       - Adição da funcionalidade MAIUSCULO
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
USUARIOS="$(cat /etc/passwd | cut -d : -f 1)"
MENSAGEM_USO="
  $(basename $0) - [OPÇÕES]

    -h - Menu de ajuda
    -v - Versão do programa
    -s - Ordenar a saída
    -m - Coloca em maiusculo
"

VERSAO="v1.2"

CHAVE_ORDENA=0
CHAVE_MAIUSCULO=0
# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
case "$1" in
  -h) echo "$MENSAGEM_USO" && exit 0 ;;
  -v) echo "$VERSAO" && exit 0       ;;
  -s) CHAVE_ORDENA=1                 ;;
  -m) CHAVE_MAIUSCULO=1              ;;
   *) echo "$USUARIOS"               ;;
esac

[ $CHAVE_ORDENA -eq 1 ] && echo "$USUARIOS" | sort -h && exit 0
[ $CHAVE_MAIUSCULO -eq 1 ] && echo "$USUARIOS" | tr [a-z] [A-Z] && exit 0
# ------------------------------------------------------------------------ #
