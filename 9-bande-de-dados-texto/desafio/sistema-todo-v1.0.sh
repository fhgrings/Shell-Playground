#!/usr/bin/env bash
#
# sistema-de-tarefas.sh - Sistema de organização pessoal para administração das tarefas
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá apresentar em ordem de prioridade todas as tarefas com seus prazos
#
#  Exemplos:
#      $ ./sistemas-de-usuairos.sh 1:Trabalho Arq II:17/07
#      Neste exemplo irá adiconar a tarefa "Trabalho Arq II" com prioridade 1 e prazo "17/07".
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 13/10/2020, Felipe:
#       - Início do programa
#       - Conta com a funcionalidade
#             - Ler banco de dados
#             - Listar Tarefas
#             - Adicionar Tarefas
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
ARQUIVO_BANCO_DE_DADOS="banco-de-dados.txt"

SEPARADOR=":"
TEMP_FILE="TEMP.$$"

VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

[ ! -e "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de escrita." && exit 1

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
MostraTarefasNaTela () {
  local prioridade="$(echo $1 | cut -d $SEPARADOR -f 1)"
  local nome="$(echo $1 | cut -d $SEPARADOR -f 2)"
  local prazo="$(echo $1 | cut -d $SEPARADOR -f 3)"

  echo -e "${VERDE}Prioridade:  ${VERMELHO}$prioridade"
  echo -e "${VERDE}Nome:  ${VERMELHO}$nome"
  echo -e "${VERDE}Prazo:  ${VERMELHO}$prazo"
}
ListaTarefas () {
  while read -r linha
  do
    [ ! "$linha" ] && continue
    [ "$(echo $linha | cut -c1)" = "#" ] && continue
    MostraTarefasNaTela "$linha"

  done < "$ARQUIVO_BANCO_DE_DADOS"
}

ValidaExistenciaTarefa () {
  grep -i -q "$1$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS"
}

ValidaInput () {
  [ ! "$(echo $1 | cut -d $SEPARADOR -f 1)" ] && return 0
  [ ! "$(echo $1 | cut -d $SEPARADOR -f 2)" ] && return 0
  [ ! "$(echo $1 | cut -d $SEPARADOR -f 3)" ] && return 0
  return 1
}

InsereTarefa () {
  if ValidaInput "$1"
  then
    echo "Input Invalido"
    return
  fi

  local nome="$(echo $1 | cut -d $SEPARADOR -f 2)"

  if ValidaExistenciaTarefa "$nome"
  then
    echo "ERRO. Tarefa ja existe"
  else
    echo "$1" >> "$ARQUIVO_BANCO_DE_DADOS"
    echo "Tarefa cadastrada com sucesso!"
  fi
  OrdenaLista
}

ApagaTarefa () {
  if ValidaExistenciaTarefa "$1"
  then
    echo "Tarefa inexistente"
    return
  fi

  grep -i -v "$1$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"

  echo "Tarefa removida com sucesso"
  OrdenaLista
}

OrdenaLista () {
  sort -h "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
ListaTarefas
# ------------------------------------------------------------------------ #
