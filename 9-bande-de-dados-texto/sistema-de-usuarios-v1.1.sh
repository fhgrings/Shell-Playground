#!/usr/bin/env bash
#
# sistemas-de-usuairos.sh - Sistema para uso do banco de dados em formato txt
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá interagir com a base de dados no formato txt, adicionando
#  alterar e exlcuindo os usuraios.
#
#  Exemplos:
#      $ ./sistemas-de-usuairos.sh 1:Felipe:felipe@gmail.com
#      Neste exemplo irá adiconar o usuario "Felipe" com id 1 e email "felipe@gmail.com".
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 13/10/2020, Felipe:
#       - Início do programa
#       - Conta com a funcionalidade
#             - Ler banco de dados
#             - Listar usuarios
#             - Adicionar Usuarios
#   v1.0 13/10/2020, Felipe:
#       - Funcionalidade adiconada
#             - Excluir usuario
#             - Ordenar Lista
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
  OrdenaLista
}

ApagaUsuario () {
  ValidaExistenciaUsuario "$1" || (echo "Usuario inexistente" && return)

  grep -i -v "$1$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"

  echo "Usuario removido com sucesso"
  OrdenaLista
}

OrdenaLista () {
  sort -h "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
ListaUsuarios
# ------------------------------------------------------------------------ #
