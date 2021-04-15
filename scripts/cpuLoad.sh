for i in $(seq 0 50)
do
	echo Lendo
	top -n 1 -b | head | grep $(hostname) >> logfile
	sleep 10
done
