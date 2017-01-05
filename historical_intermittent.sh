lookback_count=5
newest=$(find . -name "reftest-log-*" | sort -V | tail -n1)
prevs=$(find . -name "reftest-log-*" | sort -V | tail -n$lookback_count)

# echo "FAILS"
for line in $(cat "${newest}/fails.txt")
do
  # echo "Finding " $line
  for folder in $prevs
  do
    # echo "In folder " $folder
    if grep -Rq $line $folder/passes.txt
    then
      # echo "   appeared in $folder/passes.txt"
      echo "$line"
    fi

    if grep -Rq $line $folder/fails.txt
    then
      # echo "   appeared in $folder/fails.txt"
      echo "$line"
    fi
  done
  # echo "   ---"
done
# echo "================="

for line in $(cat "${newest}/passes.txt")
do
  # echo "Finding " $line
  for folder in $prevs
  do
    # echo "In folder " $folder
    if grep -Rq $line $folder/passes.txt
    then
      # echo "   appeared in $folder/passes.txt"
      echo "$line"
    fi

    if grep -Rq $line $folder/fails.txt
    then
      # echo "   appeared in $folder/fails.txt"
      echo "$line"
    fi
  done
  # echo "   ---"
done
