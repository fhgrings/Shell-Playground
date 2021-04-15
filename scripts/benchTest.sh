syntaxhelp="
Syntax: $0 <size pr. thread> <threads> <repetitions> <hash-cmd>
Example: $0 1G 4 20 md5sum
"

if [ ! $# -eq 4 ]
then 
  echo "${syntaxhelp}"
  exit 1
fi

SIZE=$1
THREADS=$2
TESTS=$3
HASH_CMD=$4

TMP_DIR=/tmp/hashstress




CUR_DIR=`pwd`
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"
cd "${TMP_DIR}"

echo "Test config:" | tee ${CUR_DIR}/benchResult.log
echo " - Data set: $THREADS file(s) each $SIZE" | tee ${CUR_DIR}/benchResult.log
echo " - Threads: $THREADS, repetitions: $TESTS" | tee ${CUR_DIR}/benchResult.log
echo " - Hash command: $HASH_CMD" | tee ${CUR_DIR}/benchResult.log
echo ""  | tee ${CUR_DIR}/benchResult.log
echo "Start time: `date`" | tee ${CUR_DIR}/benchResult.log
echo "Generating random data file(s) ..." | tee ${CUR_DIR}/benchResult.log

for (( j = 1; j <= ${THREADS}; j++ ))
do
  touch "testdata-${j}"
  shred -n 1 -s $SIZE "testdata-${j}"
done

wait

echo "Generating reference checksum(s) ..." | tee ${CUR_DIR}/benchResult.log

for (( j = 1; j <= ${THREADS}; j++ ))
do
  $HASH_CMD "testdata-${j}" > "chkref-${j}" &
done

wait

TIME_SEC=$SECONDS
FAILURES=0

echo -n "Repetition:" | tee ${CUR_DIR}/benchResult.log | tee ${CUR_DIR}/benchResult.log
for (( i = 1; i <= ${TESTS}; i++ ))
do
  echo -n " ${i}" | tee ${CUR_DIR}/benchResult.log
  for (( j = 1; j <= ${THREADS}; j++ ))
  do
    rm -f "chktest-${j}"
    $HASH_CMD "testdata-${j}" > "chktest-${j}" &
  done

  wait

  for (( j = 1; j <= ${THREADS}; j++ ))
  do
    if ! cmp -s "chkref-${j}" "chktest-${j}"
    then
      echo ""
      echo "FAIL! Wrong checksum in thread ${j}"
      ((FAILURES += 1))
    fi
  done
done

TIME_SEC=$((SECONDS - TIME_SEC))

echo "" | tee ${CUR_DIR}/benchResult.log
echo "Cleaning up" | tee ${CUR_DIR}/benchResult.log
cd "${CUR_DIR}" | tee ${CUR_DIR}/benchResult.log
rm -rf ${TMP_DIR}

echo "Repetitions took: $TIME_SEC seconds" | tee ${CUR_DIR}/benchResult.log

if [ $FAILURES = 0 ]
then
  echo "Test result: PASS" | tee ${CUR_DIR}/benchResult.log
else
  echo "Test result: FAIL, failure count: $FAILURES" | tee ${CUR_DIR}/benchResult.log
fi
echo ""
