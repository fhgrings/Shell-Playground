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
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
USUARIOS="$(cat /etc/passwd | cut -d : -f 1)"
MENSAGEM_USO="
  $0 - [OPÇÕES]

    -h - Menu de ajuda
    -v - Versão do programa
    -s - Ordenar a saída
"

VERSAO="v1.0"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #

if [[ "$1" = "-h" ]]; then
  echo "$MENSAGEM_USO" && exit 0
fi
if [[ "$1" = "-v" ]]; then
  echo "$VERSAO" && exit 0
fi
if [[ "$1" = "-s" ]]; then
  echo "$USUARIOS" | sort -h && exit 0
fi
echo "$USUARIOS"
# ------------------------------------------------------------------------ #
