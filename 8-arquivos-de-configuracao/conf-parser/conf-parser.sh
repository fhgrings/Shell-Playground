#!/usr/bin/env bash
#
# conf-parser.sh - Busca configurações no arquivo .conf
#
# Site:       http://grings.life
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá ler e retornar as configurações do arquivo de configurações retornando
#  no formato "CONF_{Variavel}={Valor}". Pode editar o arquivo de leitura passando o parametro.
#  Arquivo Default de leitura = default.conf
#
#  Exemplos:
#      $ ./conf-parser.sh
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
ARQUIVO_DE_CONFIGURACAO="default.conf"

MENSAGEM_ERROR_404="ERRO. Arquivo não encontrado"
MENSAGEM_ERROR_400="ERRO. Sem permissão de leitura ao arquivo"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #
[ $1 ] && ARQUIVO_DE_CONFIGURACAO="$1"
[ ! -e "$ARQUIVO_DE_CONFIGURACAO" ] && echo "$MENSAGEM_ERROR_404" && exit 1
[ ! -r "$ARQUIVO_DE_CONFIGURACAO" ] && echo "$MENSAGEM_ERROR_400" && exit 1
# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
while read -r linha
do
  [ "$(echo $linha | cut -c1)" = "#" ] && continue
  [ ! $linha ] && continue
  echo "CONF_$linha"
done < "$ARQUIVO_DE_CONFIGURACAO"
# ------------------------------------------------------------------------ #
