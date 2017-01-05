#!/usr/bin/env bash

intermittent() {
  sort ${1}/fails.txt > /tmp/001.txt
  sort ${2}/passes.txt  > /tmp/002.txt
  comm -1 -2 /tmp/001.txt /tmp/002.txt
}

newest=$(find . -name "reftest-log-*" | sort -V | tail -n1)
prev=$(find . -name "reftest-log-*" | sort -V | tail -n2 | head -n1)
intermittent $newest $prev
intermittent $prev $newest
