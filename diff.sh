#!/usr/bin/env bashes

compare() {
  filename=$3
  echo "Carryover $filename"
  sort ${1}/$filename > /tmp/001.txt
  sort ${2}/$filename > /tmp/002.txt
  comm -1 -2 /tmp/001.txt /tmp/002.txt
}

newest=$(find . -name "reftest-log-*" | sort -V | tail -n1)
prev=$(find . -name "reftest-log-*" | sort -V | tail -n2 | head -n1)

echo "$newest <-> $prev"

compare $newest $prev crashes.txt
compare $newest $prev fails.txt
compare $newest $prev timeout.txt
compare $newest $prev load_fail.txt
