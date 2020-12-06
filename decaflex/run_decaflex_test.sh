#!/usr/bin/env bash
for f in testcases/test/*;
do
 FILENAME="${f##*/}";
 FNAME="${FILENAME%%.*}";
 ERROR=$(cat $f | answer/decaflex 2>&1 >/dev/null);
 OUTPUT=$(cat $f | answer/decaflex>&1 2>/dev/null);
 retVal=$?
 if [ $retVal -ne 0 ]; then
 	printf "%s\n" "outputtest/$FNAME.err";
 	printf "%s\n" "$ERROR";
 	echo "1" > testcases/outputtest/$FNAME.ret;
 else
 	printf "%s" "$OUTPUT" > testcases/outputtest/$FNAME.out;
 fi
done
