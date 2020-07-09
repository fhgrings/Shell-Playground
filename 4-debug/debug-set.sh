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
#   v1.3 09/07/2020, Felipe:
#       - Adição de While
#       - Combinação das flags atribuindo o valor a variavel USUARIOS
#   v1.4 09/07/2020, Felipe:
#       - Adicionado ferramentas para debug (set -x)
#       - Combinação das flags atribuindo o valor a variavel USUARIOS
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

VERSAO="v1.4"

CHAVE_ORDENA=0
CHAVE_MAIUSCULO=0
# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
while test -n "$1"
do
  case "$1" in
    -h) echo "$MENSAGEM_USO" && exit 0                ;;
    -v) echo "$VERSAO" && exit 0                      ;;
    -s) CHAVE_ORDENA=1                                ;;
    -m) CHAVE_MAIUSCULO=1                             ;;
     *) echo "Opção inválida, valide 0 -h." && exit 1 ;;
  esac
  shift
done
set -x
[ $CHAVE_ORDENA -eq 1 ] && USUARIOS=$(echo "$USUARIOS" | sort)
[ $CHAVE_MAIUSCULO -eq 1 ] && USUARIOS=$(echo "$USUARIOS" | tr [a-z] [A-Z])
set +x
echo "$USUARIOS"
# ------------------------------------------------------------------------ #
