# Usage: ./summarize_log.sh <reftest log folder>
for f in $(ls "${1}" | sort -V)
do
  echo "FILENAME: ${f}"
  # jq '. | select(.status=="FAIL") | .test' "${1}/${f}" | sed "s/==.*$//g" | sed "s/^\"//g" >> fails.txt
  jq '. | select(.status=="FAIL" and ((.message | contains("timed out")) | not)) | .test' "${1}/${f}" | sed "s/==.*$//g" | sed "s/^\"//g" >> fails.txt
  jq '. | select(.status=="PASS") | .test' "${1}/${f}" | sed "s/==.*$//g" | sed "s/^\"//g" >> passes.txt
  jq '. | select(has("stackwalk_stdout")) | .test' ${1}/${f} >> crashes.txt
  jq '. | select(.message | contains("timed out")) | .test'  "${1}/${f}" | sed "s/==.*$//g" | sed "s/^\"//g" >> timeout.txt
  jq '. | select(.message | contains("load fail")) | .test'  "${1}/${f}" | sed "s/==.*$//g" | sed "s/^\"//g" >> load_fail.txt
done

mv fails.txt ${1}
mv passes.txt ${1}
mv crashes.txt ${1}
mv timeout.txt ${1}
mv load_fail.txt ${1}
