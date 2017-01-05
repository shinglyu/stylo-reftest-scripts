for name in crashes fails intermittent load_fail passes timeout
do
  for f in $(find . -name "reftest-log-*")
  do
    echo $f
    cat "${f}/${name}.txt" >> "summary/${name}.tmp"
  done
  sort "summary/${name}.tmp" | uniq > "summary/${name}.sorted.txt"
done

for name in fails passes
do
  comm -2 -3 "summary/${name}.sorted.txt" "summary/intermittent.sorted.txt" > "summary/${name}.no-intermittent.sorted.txt"
done

