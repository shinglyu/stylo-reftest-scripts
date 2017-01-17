PASS=$(find . -name *-stylo.list | xargs grep -h -e "==" -e loads| grep -hv "^#" | grep -hv "^fails" | wc -l)
FAIL=$(find . -name *-stylo.list | xargs grep -h "^fails" | wc -l)
DISABLE=$(find . -name *-stylo.list | xargs grep -h "^#.*==" | wc -l)

echo -e "passes\t\t$PASS"
echo -e "expected-fails\t$FAIL"
echo -e "disabled\t$DISABLE"
echo -en "total\t\t"
echo $(expr $PASS + $FAIL + $DISABLE)
