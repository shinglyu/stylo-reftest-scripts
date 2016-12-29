#!/usr/bin/env bash
# Give path to the folder containing the crashes.txt and fails.txt files

export SHELL=$(type -p bash)

mark_as_disabled() {
  echo "new disabled: ${1}"
  grep -R "${1}" . --include *-stylo.list -l | xargs -L1 sed -i "/$1/s/^/# /"
}
export -f mark_as_skip

mark_as_fail() {
  echo "new fail: ${1}"
  grep -R "${1}" . --include *-stylo.list -l | xargs -L1 sed -i "/$1/s/^/fails /"
}
export -f mark_as_fail

unmark_as_fail() {
  echo "new pass: ${1}"
  grep -R "${1}" . --include *-stylo.list -l | xargs -L1 sed -i "/$1/s/^fails //"
}

# Too many arguments breaks xargs, so we use for loop
cat ${1}/crashes.txt | sed 's/\"//g' | xargs -L1 -I{} basename {} | xargs parallel -N1 mark_as_disabled:::
#do
#  mark_as_skip "${i}"
#done

cat ${1}/fails.txt | sed 's/\"//g' | xargs -L1 -I{} basename {} | xargs parallel -N1 mark_as_fail :::

# test that timeout will make expected-fail break, so use skip
cat ${1}/timeout.txt | sed 's/\"//g' | xargs -L1 -I{} basename {} | xargs parallel -N1 mark_as_disabled:::

# for i in $(cat ${1}/fails.txt | sed 's/\"//g' | xargs -L1 -I{} basename {})
# # for i in $(grep 'UNEXPECTED-FAIL' "${1}" | grep -Po '(?<=\| )(.*)(?===)' | xargs -L1 -I{} basename {})
# do
#   mark_as_fail "${i}"
# done
#
# for i in $(grep 'UNEXPECTED-PASS' "${1}" | grep -Po '(?<=\| )(.*)(?===)' | xargs -L1 -I{} basename {})
# do
#   echo "passes ${i}"
#   unmark_as_fail "${i}"
# done
#
while grep -R "fails fails " --include *-stylo.list -q
do
  echo "Clean up multiple fails"
  find . -name *-stylo.list | xargs sed -i 's/fails fails /fails /g'
done
while grep -R "skip skip " --include *-stylo.list -q
do
  echo "Clean up multiple skips"
  find . -name *-stylo.list | xargs sed -i 's/skip skip /skip /g'
done

find . -name *-stylo.list | xargs sed -i 's/^fails #/#/g'
find . -name *-stylo.list | xargs sed -i 's/^skip #/#/g'
find . -name *-stylo.list | xargs sed -i 's/^fails load/skip load/g'
find . -name *-stylo.list | xargs sed -i 's/^skip fails /skip /g'
find . -name *-stylo.list | xargs sed -i "s/^fails \(.* load \)/skip \1/g" # fails doesn't work on load test, use skip instead
find . -name *-stylo.list | xargs sed -i 's/fails .*-if.* ==/fails ==/g' # "fails fuzzy-if" will resolve to fuzzy-if
find . -name *-stylo.list | xargs sed -i 's/fails fuzzy.* ==/fails ==/g' # "fails fuzzy-if" will resolve to fuzzy-if
find . -name *-stylo.list | xargs sed -i 's/^# fails /# /g' # from mark_as_skip and fails
