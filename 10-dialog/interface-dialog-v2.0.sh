#!/usr/bin/env bash
#
# interface-dialog.sh - Sistema para uso do banco de dados em formato txt
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
#      $ ./interface-dialog.sh 1:Felipe:felipe@gmail.com
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
#   v1.1 13/10/2020, Felipe:
#       - Funcionalidade adiconada
#             - Excluir usuario
#             - Ordenar Lista
#   v2.0 13/10/2020, Felipe:
#       - Nome alterado de "sistema-de-usuarios" para "interface-dialog"
#       - Refatorado para utilizar interface gráfica disponibilizada
#       pelo Dialog
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
[ ! -x "$(which dialog)" ] && sudo apt install dialog 1> /dev/null 2>&1

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
ListaUsuarios () {
  egrep -v "^#|^$" "$ARQUIVO_BANCO_DE_DADOS" | tr : ' ' > "$TEMP_FILE"
  dialog --title "Lista de Usuários" --textbox "$TEMP_FILE" 20 40
  rm -f "$TEMP_FILE"
}

ValidaExistenciaUsuario () {
  grep -i -q "$1$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS"
}

InsereUsuario () {
  local ultimo_id="$(egrep -v "^#|^$" $ARQUIVO_BANCO_DE_DADOS | sort -h | tail -n 1 | cut -d $SEPARADOR -f 1)"
  local proximo_id="0"$(($ultimo_id+1))

  local nome=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu nome" 0 40)
  ValidaExistenciaUsuario "$nome" && {
    dialog --title "ERRO FATAL!" --msgbox "Usuário já cadastrado" 6 40
    exit 1
  }

  local email=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu email" 0 40)

  echo $proximo_id$SEPARADOR$nome$SEPARADOR$email >> "$ARQUIVO_BANCO_DE_DADOS"

  dialog --title "SUCESSO" --msgbox "Usuário adicionado!" 6 40
  OrdenaLista

  ListaUsuarios
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
# ListaUsuarios
# ------------------------------------------------------------------------ #
