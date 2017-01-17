#!/usr/bin/env bash

if [ "${1}" != "--rerun" ]; then
  python download_artifact.py
fi
path=$(find . -name "reftest-log-*" | sort -V | tail -n1)

bash summarize_log.sh "${path}"
# bash intermittent.sh > "${path}/intermittent.txt"
# bash intermittent.sh | uniq > "${path}/intermittent.txt"
bash historical_intermittent.sh | uniq > "${path}/intermittent.txt"
vim ${path}/*.txt


echo ""
echo "Press Enter to continue comitting..."
read

cd ../stylo-incubator
git branch
echo ""
echo "Is this the branch you are expecting?..."
read

bash ../reftest/mark_expected_fails.sh ../reftest/${path}

echo "==============================================="
cd ../reftest
bash diff.sh
cd ../stylo-incubator
echo "==============================================="
echo "Press Enter to continue..."
read

git diff
git add -u
git status -v
echo ""
echo "Press Enter to continue..."
read
git commit -m "More failures"
./mach try -p linux64-stylo -b o -u reftest-stylo -t none

ringring sleep 45m
