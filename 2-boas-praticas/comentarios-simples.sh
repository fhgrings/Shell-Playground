#!/usr/bin/env bash

#Lynx instalado?
[ ! -x "$(which lynx)" ] && printf "${AMARELO} Precisamos Instalar o ${VERDE}Lynx${AMARELO}, por favor, digite sua senha:${SEM_COR}\n" && sudo apt instal lynx 1 > /dev/null 2>&1 -y


#Sem parametros obrigatórios?
[ -z $1 ] && printf "${VERMELHO}[ERRO] - Informe os parametros obrigatórios. Consulte a opção -h.\n" && exit 1
