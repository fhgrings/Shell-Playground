#!/usr/bin/env bash

echo "====== For 1"
for (( i = 0; i < 10; i++ )); do
  echo $i
done

echo "====== For 2 (seq)"
for i in $(seq 10)
do
  echo $i
done


echo "====== For 3 (array)"
Frutas=(
"Laranja"
"Ameixa"
"Abacaxi"
"Melancia"
"Jabuticaba"
)

for i in "${Frutas[@]}"; do
  echo "$i"
done

echo "===== While"
contador=0
while [[ $contador -lt ${#Frutas[@]} ]]; do
  echo $contador ${Frutas[$contador]}
  contador=$(($contador+1))
done

echo "Tarefas 2 - laços "
for i in $(seq 0 10)
do
  [ $(($i % 2)) -eq 0 ] && echo "Número $i é divisível por 2"
done
