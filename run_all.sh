#!/usr/bin/env bash

python download_artifact.py
path=$(find . -name "reftest-log-*" | sort -V | tail -n1)

bash summarize_log.sh "${path}"
vim ${path}/*.txt

bash diff.sh

echo ""
echo "Press Enter to continue comitting..."
read

cd ../stylo-incubator
git branch
echo ""
echo "Is this the branch you are expecting?..."
read

bash ../reftest/mark_expected_fails.sh ../reftest/${path}
git diff
git add -u
git status -v
echo ""
echo "Press Enter to continue comitting..."
read
git commit -m "More failures"
./mach try -p linux64-stylo -b o -u reftest-stylo -t none

