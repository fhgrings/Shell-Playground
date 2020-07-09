VAR=""
VAR2=""

if [[ "$VAR" = "$VAR2" ]]; then
  echo "São iguais if [[]];"
fi

if [[ "$VAR" = "$VAR2" ]]
then
  echo "São iguais if [[]]"
fi

if test "$VAR" = "$VAR2"
then
  echo "São iguais if test"
fi

if [ "$VAR" = "$VAR2" ]
then
  echo "São iguais if []"
fi

[ "$VAR" = "$VAR2" ] && echo "São iguais [] &&"

VAR2="Diferente"
echo "VAR2 = Diferente"

[ "$VAR" = "$VAR2" ] || echo "São diferentes [] ||"

echo "Tarefa 1"
echo "Passagem de parametro ./script.sh {numero}"
[ "$1" -gt 10 ] && echo "$$ $0"
