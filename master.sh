#!/bin/bash

# Find a URL from "noreg.txt" that matches the supplied place. Fetch the
# url and parse it with yr.awk
#
# Note the alnum-part.
#
# ... and this should be redundant. Awk executing shell to execute awk to
# execute awk.

sted=$(echo "$1" | sed 's/[^a-Z]//')
if [ "x$sted" == "x" ]; then
	echo "Feil"
	exit;
fi

#gawk -v sted=$sted 'BEGIN {print length(sted),sted}'
gawk -v IGNORECASE="1" -F '\t' -v sted=$sted '$4 == "By" && $2 == sted { lenke[0]=$(NF-2); namn[0]=$8} $1 == sted { lenke[1] = $(NF-2); namn[1]=$8} $2 == sted { lenke[2] = $(NF-2); namn[2]=$8 } $4 == "By" && $0 ~ sted { lenke[3] = $(NF-2); namn[3]=$8 } $1 == sted { lenke[4] = $(NF-2); namn[4]=$8 } $0 ~ sted { lenke[5] = $(NF-2); namn[5]=$8 } END { for (i=0; i<6; i++) { if (lenke[i] != "") { system("GET "lenke[i]" | ./yr.awk -v fylke="namn[i]); exit(0); } } exit(1) }' noreg.txt

