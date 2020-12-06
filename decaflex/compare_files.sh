#!/bin/bash
for f in testcases/output/*;
do
 FILENAME="${f##*/}";
 FNAME="${FILENAME%%.*}";
 F2="references/dev/$FILENAME"
 echo "Checking $FNAME"
 diff -q -w $f "$F2"
 
done
