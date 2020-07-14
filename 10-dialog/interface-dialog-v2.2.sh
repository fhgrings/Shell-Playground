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
#   v2.1 13/10/2020, Felipe:
#       - Adicionado menu inicial de interação
#   v2.2 13/10/2020, Felipe:
#       - Tratamento de erros, cancelamento.
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

OrdenaLista () {
  sort -h "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
while :
do
  acao=$(dialog --title "Menu Gerenciamento de Usuarios 2.0" \
                --stdout \
                --menu "Escolha uma das opções abaixo" \
                0 0 0 \
                Listar "Listar todos os usuários do sistema" \
                Remover "Remover um usuário do sistema" \
                Inserir "Inserir um usuário no sistema")
  case $acao in
    Listar) ListaUsuarios    ;;
    Inserir)
        ultimo_id="$(egrep -v "^#|^$" $ARQUIVO_BANCO_DE_DADOS | sort -h | tail -n 1 | cut -d $SEPARADOR -f 1)"
        proximo_id=$(($ultimo_id+1))

        nome=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu nome" 0 40)
        [ $? -ne 0 ] && continue

        ValidaExistenciaUsuario "$nome" && {
          dialog --title "ERRO FATAL!" --msgbox "Usuário já cadastrado" 6 40
          exit 1
        }


        email=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu email" 0 40)
        [ $? -ne 0 ] && continue

        echo $proximo_id$SEPARADOR$nome$SEPARADOR$email >> "$ARQUIVO_BANCO_DE_DADOS"

        dialog --title "SUCESSO" --msgbox "Usuário adicionado!" 6 40
        OrdenaLista
    ;;
    Remover)
        usuarios="$(egrep -v "^#|^$" $ARQUIVO_BANCO_DE_DADOS | sort -h | cut -d $SEPARADOR -f 1,2 | sed "s/:/ \"/;s/$/\"/" )"
        id_usuario=$(eval dialog --stdout --menu \"Escolha um usuário:\" 0 0 0 $usuarios )
        [ $? -ne 0 ] && continue

        ValidaExistenciaUsuario "$1" || (echo "Usuario inexistente" && return)

        grep -i -v "^$id_usuario$SEPARADOR" "$ARQUIVO_BANCO_DE_DADOS" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$ARQUIVO_BANCO_DE_DADOS"
    ;;
  esac
done

# ------------------------------------------------------------------------ #
