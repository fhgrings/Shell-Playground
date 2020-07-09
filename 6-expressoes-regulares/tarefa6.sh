#!/usr/bin/env bash

GRUPOS="$(cut -d : -f 1 /etc/group)"

echo "==========Começam com letra r: "
echo "$GRUPOS" | grep "^r"

echo "==========Terminam com letra t: "
echo "$GRUPOS" | grep "t$"

echo "==========Comecam com R, terminam com T"
echo "$GRUPOS" | grep "^r.*t$"

echo "==========Terminam com E ou D"
echo "$GRUPOS" | grep "[ed]$"

echo "==========Não terminam com E ou D"
echo "$GRUPOS" | grep "[^ed]$"

echo "==========Começam com qualquer digito e a segunda letra é U ou D"
echo "$GRUPOS" | grep "^.[ud]"

echo "==========Contenham Felipe de 2 a 10 digitos"
echo "$GRUPOS" | egrep "^felipe.{2,10}h"

echo "==========Começam com R ou S usando operador OR"
echo "$GRUPOS" | egrep "^(r|s)"
