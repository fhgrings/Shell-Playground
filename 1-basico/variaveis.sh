#!/usr/bin/env bash

STRING="Felipe Grings"
echo $STRING

STRING_COM_IDENTACAO="Jornada

nas

Estrelas"
echo "$STRING_COM_IDENTACAO"

NUMERO_1=12
NUMERO_2=23
SOMA=$(($NUMERO_1+$NUMERO_2))
echo "$SOMA"

SAIDA_CAT=$(cat /etc/passwd | grep felipe)
echo $SAIDA_CAT

echo "------------------------------------"

echo "Parametros na execucao do código"
echo "Exemplo: 'ls -l'"
echo "-l é o parametro"

echo ""
echo "Parametro 1: $1"
echo "Parametro 2: $2"

echo "Todos os parametros: $*"

echo "Total de parametros: $#"

echo "Saída do ultimo comando: $?"

echo "Numero PID do processo: $$"

echo "Nome do programa sendo executado: $0"
